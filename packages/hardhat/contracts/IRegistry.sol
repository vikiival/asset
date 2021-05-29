// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IRegistry {
    // returns total user score
    function addScore(address userId, uint256 badgeId) external returns (uint256);
    function distribute(address userId) external;
    function approve(address userId) external;
    function challenge(uint256 badgeId) external payable;
    function createBadge() external returns (uint256); 
}