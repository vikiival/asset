// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import  '@openzeppelin/contracts/utils/Counters.sol';
import './Asset.sol';
import './Approval.sol';

contract Builder {
    using Counters for Counters.Counter;
    Counters.Counter private _serviceCounter;

    enum RewardType { None, Fungible, NonFungible }

    struct ServiceStruct {
        address asset;
        address approval;
        address reward;
        RewardType rewardType;
    } 
    // Factory factory;
    
    mapping(uint256 => ServiceStruct) private _availableServices;
    
    event AfterBuild(address tokenAddress);
    constructor() public {
        // factory = Factory(_factoryAddr);
    }
  
    function create(string memory name, string memory symbol) public returns (address) {
        // address ownerAddress = msg.sender;
        Asset asset = new Asset(name, symbol, address(this));
        Approval approval = new Approval(name, symbol, address(this));
        asset.setChild(approval);
        approval.setParent(asset);
        
        
    }
    
    
    
    
    
  
}