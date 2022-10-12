/**
 * @title Basis Cash Treasury contract
 * @notice Monetary policy logic to adjust supplies of basis cash assets
 * @author Summer Smith & Rick Sanchez
 */
contract Treasury is TreasuryState, ContractGuard,Initializable {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;
    using Address for address;

    /* ========== CONSTRUCTOR ========== */
    function initialize(
        address _cash, 
        address _bond,
        address _share,
        address _bOracle,
        address _sOracle,
        address _seigniorageProxy,
        address _fund,
        address _curve,
        uint256 _startTime
    ) public initializer{
        _initEpoch_(1 days, _startTime, 0); //每24小时检查一次是否可以增发
        cash = _cash;
        bond = _bond;
        share = _share;
        curve = _curve;

        bOracle = _bOracle;
        sOracle = _sOracle;
        seigniorageProxy = _seigniorageProxy;

        fund = _fund; //每次通胀会发1.5%到开发者基金

        cashPriceOne = 10**18;

     /* =================== initial value =================== */
        migrated = false;
        initialized = false;
        lastBondOracleEpoch = 0;
        bondCap = 0;

        // accumulatedSeigniorage：增发时，留给用于兑换债券时用的钱。
        // 在增发cash时，accumulatedSeigniorage+=treasuryReserve
        // 在赎回bond（燃烧bond）时，accumulatedSeigniorage减少赎回的bond的数量
        // treasuryReserve=seigniorage：本次增发量
        accumulatedSeigniorage = 0;
        fundAllocationRate = 2;
    }

    /* =================== Modifier =================== */

    modifier checkMigration {
        require(!migrated, 'Treasury: migrated');

        _;
    }

    modifier updatePrice {
        _;

        _updateCashPrice();
    }

    /* ========== VIEW FUNCTIONS ========== */

    // budget
    // 获取准备金，在通胀时优先发给债券持有人，再发给股东
    function getReserve() public view returns (uint256) {
        return accumulatedSeigniorage;
    }
    // bac发行总量 减 还未还完的债
    function circulatingSupply() public view returns (uint256) {
        return IERC20(cash).totalSupply().sub(accumulatedSeigniorage);
    }
    // 获得波动上限
    function getCeilingPrice() public view returns (uint256) {
        return ICurve(curve).calcCeiling(circulatingSupply());
    }

    // oracle
    // 获取一个cash能换多少个bond和share
    function getBondOraclePrice() public view returns (uint256) {
        return _getCashPrice(bOracle);
    }

    function getSeigniorageOraclePrice() public view returns (uint256) {
        return _getCashPrice(sOracle);
    }

    function _getCashPrice(address oracle) internal view returns (uint256) {
        try IOracle(oracle).consult(cash, 1e18) returns (uint256 price) {
            return price;
        } catch {
            revert('Treasury: failed to consult cash price from the oracle');
        }
    }

    /* ========== MUTABLE FUNCTIONS ========== */

    function _updateConversionLimit(uint256 cashPrice) internal {
        uint256 currentEpoch = Epoch(bOracle).getLastEpoch(); // lastest update time
        if (lastBondOracleEpoch != currentEpoch) {
            uint256 percentage = cashPriceOne.sub(cashPrice);
            uint256 bondSupply = IERC20(bond).totalSupply();

            bondCap = circulatingSupply().mul(percentage).div(1e18);
            bondCap = bondCap.sub(Math.min(bondCap, bondSupply));

            lastBondOracleEpoch = currentEpoch;
        }
    }

    function _updateCashPrice() internal {
        if (Epoch(bOracle).callable()) {
            try IOracle(bOracle).update() {} catch {}
        }
        if (Epoch(sOracle).callable()) {
            try IOracle(sOracle).update() {} catch {}
        }
    }

    // 购买债券（数量，校验价格），销毁bac，铸造bab
    function buyBonds(uint256 amount, uint256 targetPrice)
        external
        onlyOneBlock
        checkMigration
        checkStartTime
        checkOperator
        updatePrice
    {
        require(amount > 0, 'Treasury: cannot purchase bonds with zero amount');

        uint256 cashPrice = _getCashPrice(bOracle);
        require(cashPrice <= targetPrice, 'Treasury: cash price moved');
        // 价格小于1才可以购买
        require(
            cashPrice < cashPriceOne, // price < $1
            'Treasury: cashPrice not eligible for bond purchase'
        );
        _updateConversionLimit(cashPrice);

        amount = Math.min(amount, bondCap.mul(cashPrice).div(1e18));
        require(amount > 0, 'Treasury: amount exceeds bond cap');

        IBasisAsset(cash).burnFrom(_msgSender(), amount);
        IBasisAsset(bond).mint(_msgSender(), amount.mul(1e18).div(cashPrice));

        emit BoughtBonds(_msgSender(), amount);
    }

    // 赎回bond,用户找Treasury.sol赎回
    function redeemBonds(uint256 amount)
        external
        onlyOneBlock
        checkMigration
        checkStartTime
        checkOperator
        updatePrice
    {
        require(amount > 0, 'Treasury: cannot redeem bonds with zero amount');

        uint256 cashPrice = _getCashPrice(bOracle);
        // 要求当前价格大于getCeilingPrice()，才可以卖出
        require(
            cashPrice > getCeilingPrice(), // price > $1.05
            'Treasury: cashPrice not eligible for bond purchase'
        );

        require(
            IERC20(cash).balanceOf(address(this)) >= amount,
            'Treasury: treasury has no more budget'
        );

        accumulatedSeigniorage = accumulatedSeigniorage.sub(
            Math.min(accumulatedSeigniorage, amount)
        );

        IBasisAsset(bond).burnFrom(_msgSender(), amount);
        IERC20(cash).safeTransfer(_msgSender(), amount);

        emit RedeemedBonds(_msgSender(), amount);
    }

    //分配增发量，判断什么时候可以增发
    function allocateSeigniorage()
        external
        onlyOneBlock
        checkMigration
        checkStartTime
        checkEpoch
        checkOperator
    {
        _updateCashPrice();
        // cashPrice：当前cash价格
        uint256 cashPrice = _getCashPrice(sOracle);
        // ceilingPrice是cashprice增发的限制价
        if (cashPrice <= getCeilingPrice()) {
            return; // just advance epoch instead revert
        }

        // circulating supply
        // 计算cashPrice超过的比例
        uint256 percentage = cashPrice.sub(cashPriceOne);
        //计算应该增发多少
        uint256 seigniorage = circulatingSupply().mul(percentage).div(1e18);
        // 为Treasurt.sol铸造，进行增发
        IBasisAsset(cash).mint(address(this), seigniorage);

        // ======================== BIP-3
        // 增发量的一部分要给基金会
        uint256 fundReserve = seigniorage.mul(fundAllocationRate).div(100);
        if (fundReserve > 0) {
            IERC20(cash).safeIncreaseAllowance(fund, fundReserve);
            ISimpleERCFund(fund).deposit(
                cash,
                fundReserve,
                'Treasury: Seigniorage Allocation'
            );
            emit FundedToCommunityFund(block.timestamp, fundReserve);
        }
        // 增发量减少fundReserve
        seigniorage = seigniorage.sub(fundReserve);

        // ======================== BIP-4
        // treasuryReserve是还未兑现的债券的钱，要给债券留着以备将来
        // 如果剩的少，就全留着。如果剩的多，就留出来债券的钱。
        // 准备金相比债券不够支付的部分：IERC20(bond).totalSupply().sub(accumulatedSeigniorage)
        uint256 treasuryReserve =
            Math.min(
                seigniorage,
                IERC20(bond).totalSupply().sub(accumulatedSeigniorage)
            );
            // 如果钱全都留了下来，treasury乘80%===============================================================
        if (treasuryReserve > 0) {
            if (treasuryReserve == seigniorage) {
                treasuryReserve = treasuryReserve.mul(80).div(100);
            }
            accumulatedSeigniorage = accumulatedSeigniorage.add(
                treasuryReserve
            );
            emit TreasuryFunded(block.timestamp, treasuryReserve);
        }

        // seigniorage
        // 如果增发量还有剩余，会转给seigniorageProxy.sol
        seigniorage = seigniorage.sub(treasuryReserve);
        if (seigniorage > 0) {
            IERC20(cash).safeIncreaseAllowance(seigniorageProxy, seigniorage);
            // 调用allocateSeigniorage函数可以把钱转给seigniorageProxy.sol
            SeigniorageProxy(seigniorageProxy).allocateSeigniorage(seigniorage);
            emit SeigniorageDistributed(block.timestamp, seigniorage);
        }
    }

    // CORE
    event RedeemedBonds(address indexed from, uint256 amount);
    event BoughtBonds(address indexed from, uint256 amount);
    event TreasuryFunded(uint256 timestamp, uint256 seigniorage);
    event SeigniorageDistributed(uint256 timestamp, uint256 seigniorage);
    event FundedToCommunityFund(uint256 timestamp, uint256 seigniorage);
}


