pragma solidity >=0.6.12;

interface IAddressMap {
    function isManager(address _mAddr) external view returns (bool);

    function isMarket(address _mAddr) external view returns (bool);

    function getAddr(string calldata _name) external view returns (address);
}
