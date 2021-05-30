// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './IChild.sol';

interface IAccess is IChild {
    function create(address renter, uint256 carTokenId, uint256 period) external returns (uint256);
    function finish(uint256 tokenId) external returns (uint256);
    function isChildFor() external view returns (address);
}