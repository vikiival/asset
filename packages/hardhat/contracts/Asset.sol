// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import './IAsset.sol';
import './IAccess.sol';

contract Asset is ERC721, Ownable, IAsset {
    using Counters for Counters.Counter;
    Counters.Counter private assetId;

    mapping (uint => uint) private _used;
    
    IAccess access;

    event Rent(uint indexed _asset, uint indexed _access, uint indexed _period);
    event Created(uint indexed _asset);
    event Finished(uint indexed _asset);


    constructor(string memory name, string memory symbol, address owner) ERC721(name, symbol) public {
        transferOwnership(owner);
    }

    function currentId() public view returns (uint) {
        return assetId.current();
    }
  
    function setChild(address child) override public onlyOwner {
        access = IAccess(child);
    }
    
    
    function isAvailable(uint256 tokenId)  public view created(tokenId) override returns (bool) {
        return _used[tokenId] == 0;
    }

    // DEV: Create car
    function create(string memory tokenURI) public override returns (uint256) {
        assetId.increment();
        uint256 tokenId = assetId.current();
        
        _mint(msg.sender, tokenId);
        // _setTokenURI(assetId, tokenURI);
        _approveFor(tokenId, msg.sender, 1);
        emit Created(tokenId);
        return tokenId;
        // emit CreateCarEmitter(assetId); // Triggering event
    }


    function _approveFor(uint256 _id, address _to, uint _length) internal returns (uint) {
        return access.create(_to, _id, _length);
    }

      function _denyAccess(uint256 _id) internal returns (uint) {
        return access.finish(_id);
    }

    modifier created(uint _id) {
       require(_exists(_id), "ERC721: operator query for nonexistent token");
       _;
    }
    
    function rent(uint256 tokenId, uint _minutes)  public payable override {
        require(isAvailable(tokenId), "Asset is not available");
        uint length = _minutes * 1 minutes;
        require(length >= 15 minutes, "At least 15 min rental");
        require(msg.value >= 0, "Not enough money to rent");


        uint accessToken = _approveFor(tokenId, msg.sender, _minutes);
        _used[tokenId] = accessToken;
        emit Rent(tokenId, accessToken, length);
    }

    function masterAccess(uint256 tokenId, address _to) public onlyAssetOwner(tokenId) {
        _approveFor(tokenId, _to, 1);
    }

    function finish(uint256 tokenId) public created(tokenId) {
        uint accessToken = _used[tokenId];
        // require(access.ownerOf(accessToken) == msg.sender, "Only Owner can finish");
        access.finish(accessToken);
    }

    modifier onlyAssetOwner(uint256 _id) {
       require(ownerOf(_id) == msg.sender, "Only asset owner is eligible to perform this operation");
       _;
    }
    
    function isParentFor() public view override returns (address) {
        return address(access);
    }

    
    function rewardAt()  public view override returns (address) {
        return address(0);
    } 
}
