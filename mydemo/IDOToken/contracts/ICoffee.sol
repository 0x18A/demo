// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (interfaces/IERC777Sender.sol)

pragma solidity >=0.6.12;


interface ICoffee{
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function getSentCOFPromote(address _user)external returns(uint); //展示
    function getSentCOFHigherUp(address _user)external view returns(address); //获取上级

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}
