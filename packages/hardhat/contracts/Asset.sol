// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import './IAsset.sol';
import './IAccess.sol';

contract Asset is ERC721, Ownable, IAsset {
    uint256 carTokenId = 0;
    
    IAccess approval;
    constructor(string memory name, string memory symbol, address owner) ERC721(name, symbol) public {
        transferOwnership(owner);
    }
  
    function setChild(IAccess _approval) public onlyOwner {
        approval = _approval;
    }
    
    
    function isAvailable(uint256 tokenId)  public view override returns (bool) {
        return tokenId % 2 == 0 ? true : false;
    }
    
    function create(string memory tokenURI)  public override returns (uint256) {
        carTokenId += 1;
        
        _mint(msg.sender, carTokenId);
        // _setTokenURI(carTokenId, tokenURI);
        approval.create(msg.sender, carTokenId, 0);
        // emit CreateCarEmitter(carTokenId); // Triggering event
    }
    



    
    function rent(uint256 tokenId)  public view override returns (uint256) {
        return tokenId;
    }
    
    function isParentFor() public view override returns (address) {
        return address(approval);
    }
    
    function rewardAt()  public view override returns (address) {
        return address(0);
    }
    
    
  
  
  
  
  
}
