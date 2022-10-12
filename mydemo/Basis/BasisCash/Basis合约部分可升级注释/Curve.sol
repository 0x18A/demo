contract LinearThreshold is Operator, Curve,Initializable {
    using SafeMath for uint256;

    /* ========== CONSTRUCTOR ========== */
    // 货币供应量越多，就越要求货币的价格减少波动
    /**
    @param _minSupply BAC的最小发行量，小于这个值波动上限为上限的最大值
    @param _maxSupply BAC的最大发行量，大于这个量，波动上限为上限的最小值
    @param _minCeiling 上限最小值
    @param _maxCeiling 上限最大值
     */
    function initialize(
        uint256 _minSupply,
        uint256 _maxSupply,
        uint256 _minCeiling,
        uint256 _maxCeiling
    ) public initializer{
        minSupply = _minSupply;
        maxSupply = _maxSupply;
        minCeiling = _minCeiling;
        maxCeiling = _maxCeiling;
    }

    /* ========== GOVERNANCE ========== */

    function setMinSupply(uint256 _newMinSupply) public override onlyOperator {
        super.setMinSupply(_newMinSupply);
    }

    function setMaxSupply(uint256 _newMaxSupply) public override onlyOperator {
        super.setMaxSupply(_newMaxSupply);
    }

    function setMinCeiling(uint256 _newMinCeiling)
        public
        override
        onlyOperator
    {
        super.setMinCeiling(_newMinCeiling);
    }

    function setMaxCeiling(uint256 _newMaxCeiling)
        public
        override
        onlyOperator
    {
        super.setMaxCeiling(_newMaxCeiling);
    }

    /* ========== VIEW FUNCTIONS ========== */

    function calcCeiling(uint256 _supply)
        public
        view
        override
        returns (uint256)
    {
        if (_supply <= minSupply) {
            return maxCeiling;
        }
        if (_supply >= maxSupply) {
            return minCeiling;
        }
        // 如果介于两者之间，上下限需要计算
        uint256 slope =
            maxCeiling.sub(minCeiling).mul(1e18).div(maxSupply.sub(minSupply));
        uint256 ceiling =
            maxCeiling.sub(slope.mul(_supply.sub(minSupply)).div(1e18));

        return ceiling;
    }
}