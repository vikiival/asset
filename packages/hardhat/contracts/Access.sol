// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import './IAsset.sol';
import './IAccess.sol';

contract Access is ERC721, Ownable, IAccess {
    
     mapping (uint => uint) private _accessPeriods;
    
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
        _mint(renter, carTokenId);
        if (period > 1) {
            _accessPeriods[carTokenId] = block.timestamp + period;    
        } else {
            // TODO: need to chceck if is car owner;
            _accessPeriods[carTokenId] = 0;    
        }
        
        return carTokenId;
        
    }
    
    function finish(uint accessId) public override onlyParent returns (uint) {
        _accessPeriods[accessId] = 0;
        _burn(accessId);
    }
    
    function isChildFor() public view override returns (address) {
        return address(asset);
    }
    
  
  
  
  
  
}
