// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import '@openzeppelin/contracts/access/Ownable.sol';
import './IRegistry.sol';
import './BadgeManager.sol';

contract Registry is IRegistry, Ownable {
    struct Challenge {
        int8 score;
        uint badgeId;
        mapping(address => int8) judgments;
    }
    

    BadgeManager private _badgeManager;
    address[] _judges;
    uint8 private _maxJudges;
        // mapping(uint256 => Challenge) public _challenges;
    mapping(address => Challenge) private _challenges;
    mapping (address => uint) private _stakes;


    

    constructor (uint8 _max) {
        _badgeManager = new BadgeManager("Badge Curated Registry", "BCR");
        _maxJudges = _max;
        if (_max > 0) {
            _judges.push(msg.sender);
        } 
    }
     
    function addScore(address userId, uint256 badgeId) public override returns (uint256) {
        
        return 1;
    }
    
    function distribute(address _to) public override {
        uint value = _stakes[_to] / _judges.length;
        // for (uint8 index = 0; index < _judges.length; index++) {
        //     _judges.send(value);
        // }
    }
    
    function approve(address _to) public override {
        uint _id = _challenges[_to].badgeId;
        _badgeManager.obtain(_to, _id);
    }
    
    
    function resolve(address _to) public {
        if (_challenges[_to].score > int8(approvalCount())) {
            approve(_to);
        } else {
            distribute(_to);
        }
    }

    function judge(address _for, bool _judgement) public {
        if (_judgement) {
            _challenges[_for].score += 1;
        } else {
            _challenges[_for].score -= 1;
        }
        
    }

    function isJudge(uint8 _id) public view returns (bool) {
        return _judges[_id] == msg.sender;
    }
    
    // onlyOwner
    function addJudge(address _judge) public {
        require(_maxJudges > _judges.length, "No more judges sorre");
        _judges.push(_judge);
    }

    function approvalCount() public view returns (uint8) {
        return  _maxJudges * 0;
    }

    function challenge(uint256 _id) public override payable onlyOne {
        uint8 score = _badgeManager.getScore(_id);
        uint256 stake = _badgeManager.getStake(_id);
        
        require(msg.value >= stake, "Stake is too low");
        
        // TODO: user can already have that badge
        _stakes[msg.sender] = msg.value;
        set(msg.sender, _id);
    }

    function set(address _to, uint _id) internal {
        Challenge storage e = _challenges[_to];
        e.badgeId = _id;
        e.score = 0;
    }
    
    modifier onlyOne() {
       require(_challenges[msg.sender].badgeId >= 0, "Caller has already a challenge");
       _;
    }
    
    function createBadge() public override onlyOwner returns (uint256) {
        
    }
} 