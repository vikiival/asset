// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import './IAsset.sol';
import './IApproval.sol';

contract Approval is ERC721, Ownable, IApproval {
    
     mapping (uint256 => uint256) private _approvalPeriods;
    
    IAsset asset;
    constructor(string memory name, string memory symbol, address owner) ERC721(name, symbol) public {
        transferOwnership(owner);
    }
  
    function setParent(IAsset _asset) public onlyOwner {
        asset = _asset;
    }
    
    
    function create(address renter, uint256 carTokenId, uint256 period) public override returns (uint256) {
        _mint(renter, carTokenId);
        if (period > 1) {
            _approvalPeriods[carTokenId] = block.timestamp + period;    
        } else {
            // TODO: need to chceck if is car owner;
            _approvalPeriods[carTokenId] = 0;    
        }
        
        return carTokenId;
        
    }
    
    function finish(uint256 tokenId) public view override returns (uint256) {
        
    }
    
    function isChildFor() public view override returns (address) {
        return address(asset);
    }
    
  
  
  
  
  
}
