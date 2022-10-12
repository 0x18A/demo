pragma solidity >=0.6.12;

interface IExchange {
    /**
    @dev 用户进行存款
    @param _amount  用户购买的份额，即获得的mdr的数量
     */
    function deposit(uint256 _amount) external;

    /**
     @dev 用户领取当前可以领取的收益
      */
    function harvest() external;

    /***
      @dev 用户可以领取的收益
       */
    function pending(address _user) external view returns (uint256);

    /**
    @dev 聚合函数
    @param  _user       指定用户
    @return allowance   用户代币的授权金额
    @return balance     用户代币资产
    @return amount      用户的有效质押金额
    @return received    用户已经领取的收益
    @return pendingToken   用户当前可以领取的收益
     */
    function argInfo(address _user)
        external
        view
        returns (
            uint256 allowance,
            uint256 balance,
            uint256 amount,
            uint256 received,
            uint256 pendingToken
        );

    /**
    @dev 获取活动信息
    @return _startTime      活动开启时间，10位时间戳
    @return _totalShare     总份额
    @return _useShare       已经认购的份额
    @return _price          价格1uft可以兑换到的mdr数量
    @return _cycle          活动锁仓周期
     */
    function getActive()
        external
        view
        returns (
            uint256 _startTime,
            uint256 _totalShare,
            uint256 _useShare,
            uint256 _price,
            uint256 _cycle
        );
}
