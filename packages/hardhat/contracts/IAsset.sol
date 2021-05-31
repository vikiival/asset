// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './IParent.sol';

interface IAsset is IParent {
    function isAvailable(uint256 tokenId) external view returns (bool);
    function create(string memory tokenURI) external returns (uint256);
    function rent(uint256 tokenId, uint _minutes) external payable;
    function isParentFor() external view returns (address);
    function rewardAt() external view returns (address);
}