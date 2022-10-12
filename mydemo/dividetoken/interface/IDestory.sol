pragma solidity >=0.6.12;

interface IDestory {
    /**
    @dev 用户订单结构体
    @param  amount  金额
    @param  time    质押时间
     */
    struct UserOrder {
        uint256 amount;
        uint256 time;
    }

    /**
    @dev 用户进行销毁,nft质押之后不能解押，直接进行销毁，只用记录用户销毁数量即可
    @param _tokenId 质押的nftId，需要提前授权
     */
    function deposit(uint256 _tokenId) external;

    /**
    @dev 用户领取当前可以领取的收益
     */
    function harvest() external;

    /**
    @dev 获取用户可以领取的收益
     */
    function pending(address _user) external view returns (uint256);

    /**
    @dev 聚合函数
    @param  _user       指定用户
    @return _isApprove   用户NFT的授权情况,是否已经全部授权
    @return _amount      用户的有效质押金额
    @return _received    用户已经领取的收益
    @return _pendingToken   用户当前可以领取的收益
    @return _nftTotal   用户质押的nft数量,
     */
    function argInfo(address _user)
        external
        view
        returns (
            bool _isApprove,
            uint256 _amount,
            uint256 _received,
            uint256 _pendingToken,
            uint256 _nftTotal
        );

    /**
    @dev 获取活动信息
    @return _startTime      活动开启时间，10位时间戳
    @return _cycle          活动锁仓周期,150就是150天
    @return _totalShare     质押总份额
    @return _useShare       质押已经使用的份额
     */
    function getActive()
        external
        view
        returns (
            uint256 _startTime,
            uint256 _cycle,
            uint256 _totalShare,
            uint256 _useShare
        );
}
