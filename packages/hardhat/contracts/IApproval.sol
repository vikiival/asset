// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IApproval {
    function create(address renter, uint256 carTokenId, uint256 period) external returns (uint256);
    function finish(uint256 tokenId) external view returns (uint256);
    function isChildFor() external view returns (address);
}