// SPDX-License-Identifier: MIT

pragma solidity >=0.6.12;
pragma experimental ABIEncoderV2;

contract Initializable {

  /**
   * @dev Indicates that the contract has been initialized.
   */
  bool private initialized;

  /**
   * @dev Indicates that the contract is in the process of being initialized.
   */
  bool private initializing;

  /**
   * @dev Modifier to use in the initializer function of a contract.
   */
  modifier initializer() {
    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");

    bool isTopLevelCall = !initializing;
    if (isTopLevelCall) {
      initializing = true;
      initialized = true;
    }

    _;

    if (isTopLevelCall) {
      initializing = false;
    }
  }

  /// @dev Returns true if and only if the function is running in the constructor
  function isConstructor() private view returns (bool) {
    // extcodesize checks the size of the code stored in an address, and
    // address returns the current address. Since the code is still not
    // deployed when running a constructor, any checks on its code size will
    // yield zero, making it an effective way to detect if a contract is
    // under construction or not.
    address self = address(this);
    uint256 cs;
    assembly { cs := extcodesize(self) }
    return cs == 0;
  }

  // Reserved storage space to allow for layout changes in the future.
  uint256[50] private ______gap;
}

interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        // }
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        // }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        // }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        // }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        // }
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        // unchecked {
            require(b <= a, errorMessage);
            return a - b;
        // }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        // unchecked {
            require(b > 0, errorMessage);
            return a / b;
        // }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        // unchecked {
            require(b > 0, errorMessage);
            return a % b;
        // }
    }
}

interface ICoffee{
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function getSentCOFPromote(address _user)external returns(uint); //展示
    function getSentCOFHigherUp(address _user)external returns(address); //获取上级

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

contract IDO is Initializable {
    using SafeMath for uint256;

    struct IDOUserInfo{
        uint totalIDO;
        uint totalReward; //coffee的reward
        uint totalPromoteAndIDO; //PromoteAndIDO总人数
        uint USDTGot; //已经领取的USDT
        uint HigherUpLock; //1代表user的上级已经被计算了PromoteAndIDO
    }
    struct PENDING{
        uint userTotalIDO; //用户总IDO
        uint userTotalReward; //用户因IDO获得的总收益
        uint userTotalPromote; //用户总推广人数
        uint userTotalPromoteAndIDO; //用户总PromoteAndIDO的人数
        uint userUSDTReward; //用户待领取的USDT收益
    }

    PENDING public pending;
    address developTeam;
    address owner;
    ICoffee public coffee;
    IERC20 public usdt;
    uint private idoRewardRatio;
    mapping(address=>IDOUserInfo) private idoUserInfo;

    event DOIDO(address indexed user,uint amount);
    event doHarvestcoffee(address indexed user,uint amount);
    event doHarvestusdt(address indexed user,uint amount);

    function initialize(ICoffee _coffee,IERC20 _usdt,address _developTeam) public initializer{
        coffee = _coffee;
        developTeam = _developTeam;
        owner = msg.sender;
        usdt = _usdt;
        idoRewardRatio = 1;
    }

    function updateidoRewardRatio(uint _idoRewardRatio) public {
        require(owner==msg.sender,"only owner");
        idoRewardRatio = _idoRewardRatio;
    }
    function updatedevelopTeam(address _developTeam) public {
        require(owner==msg.sender,"only owner");
        developTeam = _developTeam;
    }
    function updatecoffee(ICoffee _coffee) public {
        require(owner==msg.sender,"only owner");
        coffee = _coffee;
    }
    function updateusdt(IERC20 _usdt) public {
        require(owner==msg.sender,"only owner");
        usdt = _usdt;
    }

    function doIDO(uint _amount) public {
        IERC20(usdt).transferFrom(msg.sender,developTeam,_amount);
        idoUserInfo[msg.sender].totalIDO += _amount;
        
        if(_amount == 50000000000000000000){
            idoUserInfo[msg.sender].totalReward += _amount.mul(idoRewardRatio);
        }
        if(_amount == 200000000000000000000){
            idoUserInfo[msg.sender].totalReward += _amount;
            ICoffee(coffee).transferFrom(developTeam,msg.sender,200000000000000000000);
        }
        if(_amount == 500000000000000000000){
            idoUserInfo[msg.sender].totalReward += _amount;
            ICoffee(coffee).transferFrom(developTeam,msg.sender,500000000000000000000);
        }
        //上级的PromoteAndIDO+1，要求有上级，且自身没给上级贡献过
        if(ICoffee(coffee).getSentCOFHigherUp(msg.sender)!=address(0)&&idoUserInfo[msg.sender].HigherUpLock==0){
            idoUserInfo[ICoffee(coffee).getSentCOFHigherUp(msg.sender)].totalPromoteAndIDO+=1;
            idoUserInfo[msg.sender].HigherUpLock = 1;
        }
        emit DOIDO(msg.sender,_amount);
    }

    function pendingUser(address _user) external returns(PENDING memory){
        pending.userTotalIDO = idoUserInfo[_user].totalIDO.div(10**18);
        pending.userTotalReward = idoUserInfo[_user].totalReward.div(10**18);
        pending.userTotalPromoteAndIDO = idoUserInfo[_user].totalPromoteAndIDO;
        pending.userTotalPromote = ICoffee(coffee).getSentCOFPromote(_user);
        pending.userUSDTReward =  (idoUserInfo[_user].totalPromoteAndIDO).div(10).mul(100).sub(idoUserInfo[_user].USDTGot);
        return pending;
    }

    function harvestCoffee() public{
        ICoffee(coffee).transferFrom(developTeam, msg.sender, idoUserInfo[msg.sender].totalReward);
        idoUserInfo[msg.sender].totalReward = 0;
        emit doHarvestcoffee(msg.sender, idoUserInfo[msg.sender].totalReward);
    }

    function harvestUSDT() public{
        uint USDTwaiting = (idoUserInfo[msg.sender].totalPromoteAndIDO).div(10).mul(100).sub(idoUserInfo[msg.sender].USDTGot);
        IERC20(usdt).transferFrom(developTeam,msg.sender,USDTwaiting);
        idoUserInfo[msg.sender].USDTGot += USDTwaiting;
        emit doHarvestusdt(msg.sender, USDTwaiting);
    }
}