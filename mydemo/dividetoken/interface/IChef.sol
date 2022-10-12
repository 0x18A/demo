pragma solidity >=0.6.12;

interface IChef {
    /**
    @dev 外部合约调用注入手续费
     */
    function intoFee(uint256 _amount) external;

    /**
    @dev 将lp令牌存入pool进行收益
     */
    function deposit(uint256 _amount) external;

    /**
     @dev 用户领取自己的lp令牌
      */
    function withdraw(uint256 _amount) external;

    /**
      @dev 用户领取自己的收益
       */
    function harvest() external;

    /**
    @dev 获取指定用户等待领取的token奖励
     */
    function pendingToken(address _user) external view returns (uint256);

    /**
    @dev 获取聚合信息
    @param _user 用户地址
    - 用户代币授权信息
    - 用户lp资产信息
    - 用户待领取的token
    - 用户当前锁仓金额
     */
    function argToken(address _user)
        external
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            uint256
        );
}
