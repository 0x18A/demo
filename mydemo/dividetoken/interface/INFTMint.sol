pragma solidity >=0.6.12;

interface INFTMint {
    /**
    @dev    获取nft购买信息
     */
    function getNftInfo(uint256 _tokenId)
        external
        view
        returns (uint256 _price);

    /**
     @dev   修改nft的使用情况
      */
    function updateIsUsed(uint256 _tokenId) external;

    /**
    @dev 聚合函数
    - 用户token资产
    - 用户token授权金额
    - 用户是否已经申购nft
     */
    function argUser(address _user)
        external
        view
        returns (
            uint256 _balance,
            uint256 _allowance,
            bool _isMint
        );

    /**
    @dev 获取用户持有的nft的id列表
    @param  _user   用户地址
    @return  0      id数组
    @return  1      nft总数
     */
    function getUserAllNFT(address _user)
        external
        view
        returns (uint256[] memory, uint256);

    /**
    @dev 获取系统的信息
    - isActive      是否开启活动
    - price         价格
    - amount        可以出售的数量
    - totalMint     可用铸造数量
    - startTime     活动开始时间
     */
    function getActiveInfo()
        external
        view
        returns (
            bool _isActive,
            uint256 _price,
            uint256 _amount,
            uint256 _totalMint,
            uint64 _startTime
        );

    /**
    @dev   消耗代币铸造一个nft
     */
    function mintNFT() external;
}
