// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './IAbstractFactory.sol';
import './IChild.sol';
import './IParent.sol';

contract Factory {
    // using Counters for Counters.Counter;
    // Counters.Counter private _serviceCounter;

    enum RewardType { None, Fungible, NonFungible }

    struct Config {
        address builder;
        string name;
        string symbol;
    } 
    
    bytes4 _assetInterface = 0x87f6074b;
    
    event AfterBuild(address tokenAddress);
    // constructor() public {
    //     // factory = Factory(_factoryAddr);
    // }
  
    // function create(Config calldata _asset, Config calldata _access, Config calldata _reward) public returns (address) {
      
        
    // }
    
    // function create(Config calldata _asset, Config calldata _access) public returns (address) {
    // }


    function create(address builder, string memory name, string memory symbol) public returns (address) {
      Config memory _asset = Config(builder, name, symbol);
      address asset = _create(_asset, _assetInterface);
      return asset;
    }

    function _create(Config memory _config, bytes4 _requiredInterface) private returns (address) {
      IAbstractFactory builder = IAbstractFactory(_config.builder);
      require(builder.canProduce(_requiredInterface), "Required Interface does not match");
      address target = builder.deploy(_config.name, _config.symbol);
      return target;
    }

    function _parenting(IParent asset, IChild access) private {
        asset.setChild(access);
        access.setParent(asset);
    }


    
    
    
  
}