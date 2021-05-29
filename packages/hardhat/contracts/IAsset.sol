// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IAsset {
    function isAvailable(uint256 tokenId) external view returns (bool);
    function create(string memory tokenURI) external returns (uint256);
    function rent(uint256 tokenId) external view returns (uint256);
    function isParentFor() external view returns (address);
    function rewardAt() external view returns (address);
}