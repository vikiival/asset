// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IAbstractFactory {
    function deploy(string calldata _name, string calldata _symbol) external returns (address);
    function canProduce(bytes4 interfaceId) external view returns (bool);
}