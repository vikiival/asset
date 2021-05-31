// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import './IAsset.sol';
import './IAccess.sol';

contract Access is ERC721, Ownable, IAccess {
    using Counters for Counters.Counter;
    Counters.Counter private tokenId;
    
     mapping (uint => uint) private _accessPeriods;
     mapping (uint => uint) private _assetTokens;
    
    address asset;
    constructor(string memory name, string memory symbol, address owner) ERC721(name, symbol) public {
        transferOwnership(owner);
    }
  
    function setParent(address parent) public override onlyOwner {
        asset = parent;
    }


    modifier onlyParent() {
       require(msg.sender == isChildFor(), "Only parent can manipulate");
       _;
    }
    
    
    function create(address renter, uint carTokenId, uint period) public override onlyParent returns (uint) {    
        tokenId.increment();
        uint256 lockTokenId = tokenId.current();
        require(period > 0, "Invalid time period");
        // block.timestamp +
        _accessPeriods[lockTokenId] = period == 1 ? 1 : period * 1 minutes;
        _mint(renter, lockTokenId);
        _assetTokens[lockTokenId] = carTokenId;
        

        return lockTokenId;
        
    }

    function currentId() public view returns (uint) {
        return tokenId.current();
    }

    function accessPeriod(uint _id) public view created(_id) returns (uint) {
        return _accessPeriods[_id];
    }


    function assetFor(uint _id) public view created(_id) returns (uint) {
        return _assetTokens[_id];
    }
    
    function finish(uint accessId) public override onlyParent created(accessId) returns (uint) {
        _assetTokens[accessId] = 0;
        _accessPeriods[accessId] = 0;
        _burn(accessId);
        return accessId;
    }
    
    function isChildFor() public view override returns (address) {
        return address(asset);
    }

    function canAccessFor(uint _id) public view created(_id) returns (uint) {
        require(_exists(_id), "ERC721: operator query for nonexistent token");
        return _accessPeriods[_id];
    }
    
    modifier created(uint _id) {
       require(_exists(_id), "ERC721: operator query for nonexistent token");
       _;
    }
  
  
  
  
}
