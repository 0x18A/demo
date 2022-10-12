contract SeigniorageProxy is SeigniorageProxyGov,Initializable {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    function initialize(
        address _treasury,
        address _boardroom,
        address _bondroom
    ) public initializer{
        treasury = _treasury;
        boardroom = _boardroom;
        bondroom = _bondroom;
    }

    function allocateSeigniorage(uint256 _total) public onlyTreasury {
        // bondroom? boardroom?
        IERC20(TreasuryState(treasury).cash()).safeTransferFrom(
            _msgSender(),
            address(this),
            _total
        );
    }

    function collect() public onlyBoardroom returns (address, uint256) {
        address token = TreasuryState(treasury).cash();
        uint256 amount = IERC20(token).balanceOf(address(this));

        IERC20(token).safeTransfer(_msgSender(), amount);

        return (token, amount);
    }

    function emergencyWithdraw(address _token, uint256 _amount)
        public
        onlyOwner
    {
        IERC20(_token).safeTransfer(_msgSender(), _amount);
    }
}
