pragma solidity >=0.6.12;

interface IVault {
    /**
    @dev 分发销毁手续费
    @param _amount  交易总金额
    @param _user    交易发起人
     */
    function takeDestoryFee(uint256 _amount, address _user) external;

    /**
    @dev 分发卖币手续费
    @param _amount  交易总金额
    @param _user    交易发起人
    累计15% 3% 销毁  3%佣金  8%LP质押 1%品牌
     */
    function takeSellFee(uint256 _amount, address _user) external;

    /**
    @dev 分发LP挖矿手续费
    @param _amount  交易总金额
    @param _user    交易发起人
    累计15% 3% 销毁  3%佣金  8%LP质押 1%品牌
     */
    function takeLPHarvestFee(uint256 _amount, address _user) external;

    /**
    @dev 领取手续费
     */
    function harvest() external;

    /**
    @dev 获取用户指定可用的手续费
    - 销毁获得的佣金
    - 出售获得的佣金
    - 质押挖矿获得的佣金
    - 佣金总额，所有佣金的和
     */
    function pending(address _user)
        external
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256
        );
}
