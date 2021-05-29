// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import '@openzeppelin/contracts/access/Ownable.sol';
import './IRegistry.sol';
import './BadgeManager.sol';

contract Registry is IRegistry, Ownable {
    BadgeManager private _badgeManager;
    
    
    struct Challenge {
        uint rewardPool;        // (remaining) Pool of tokens to be distributed to winning voters
        address challenger;     // Owner of Challenge
        bool resolved;          // Indication of if challenge is resolved
        uint stake;             // Number of tokens at stake for either party during challenge
        mapping(address => bool) judgments; // Indicates whether a voter has claimed a reward yet
    }
    
    constructor () {
        _badgeManager = new BadgeManager("Badge Curated Registry", "BCR");
    }
    
    // mapping(uint256 => Challenge) public _challenges;
    mapping(address => uint256) private _challenges;
    mapping (address => uint) private _stakes;

     
    function addScore(address userId, uint256 badgeId) public override returns (uint256) {
        
        return 1;
    }
    function distribute(address _to) public override {
        
    }
    
    function approve(address _to) public override {
        
    }
    
    
    function resolve(address _to, uint256 _badgeId, bool _result) public onlyOwner {
        if (_result) {
            approve(_to);
        } else {
            distribute(_to);
        }
    }
    
    function challenge(uint256 _id) public override payable onlyOne {
        uint8 score = _badgeManager.getScore(_id);
        uint256 stake = _badgeManager.getStake(_id);
        
        require(msg.value >= stake, "Stake is too low");
        
        // TODO: user can already have that badge
        _stakes[msg.sender] = msg.value;
        _challenges[msg.sender] = _id;
        
        
        
    }
    
    modifier onlyOne() {
       require(_challenges[msg.sender] == 0, "Caller has already a challenge");
       _;
    }
    
    function createBadge() public override onlyOwner returns (uint256) {
        
    }
}