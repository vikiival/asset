// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BadgeManager is Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private tokenId;
    
    struct Badge {
        uint8 score;
        string title;
        bool disabled;
        uint256 stake;   
    }
    
    uint256 _lastMinted = 0;
        
    string private _name;

    // Token symbol
    string private _symbol;

    mapping(uint256 => Badge) public _badges;
    mapping(address => uint256) public _scores;
    mapping(address => mapping(uint256 => uint256)) _collectedBadges;
    
    constructor (string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }
    
    function _exists(uint256 _id) internal view returns (bool) {
        return _id <= actualTokenId() && _id != 0;
    }
    
    function actualTokenId() public view returns (uint256) {
        return tokenId.current();
    }
    
    function _mint(string memory _title, uint256 _stake, uint8 _score) internal {
        tokenId.increment();
        uint256 newTokenId = tokenId.current();
        set(newTokenId, _title, _stake, _score);
    }
    
    function set(uint256 _id, string memory _title, uint256 _stake, uint8 _score) internal {
        Badge storage e = _badges[_id];
        e.title = _title;
        e.stake = _stake;
        e.score = _score;
    }
    
    function get(uint256 _id) public view shouldExist(_id) returns (Badge memory) {
        require(_id <= actualTokenId(), "Current epoch with id does not exist");
        Badge memory e = _badges[_id];
        return e;
    }
    
    function getScore(uint256 _id) public view returns (uint8) {
      Badge memory badge = get(_id);
      return badge.score;
    }
    
    function getStake(uint256 _id) public view returns (uint256) {
      Badge memory badge = get(_id);
      return badge.stake;
    } 
    
    function obtain(address _to, uint256 _id) public shouldExist(_id) {
        Badge memory badge = get(_id);
        _scores[_to] += badge.score;
        _collectedBadges[_to][_id] = badge.score;
        
    }
    
    modifier shouldExist(uint256 _id) {
       require(_exists(_id), "Current epoch with id does not exist");
       _;
    }
    
    
    function _revoke(address _to, uint256 _id) internal {
        require(_to != address(0), "ERC721: mint to the zero address");
        
        uint256 score = _collectedBadges[_to][_id];
        
        require(score > 0, "ERC721: Cannot _revoke badge from address");
        
        _scores[_to] -= score;
        _collectedBadges[_to][_id] = 0;
    }   
}
