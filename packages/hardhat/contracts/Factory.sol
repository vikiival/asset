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
    
    bytes4 _assetInterface = 0x8b9aa81d;
    bytes4 _accessInterface = 0x78c1867b;
    address _ass;
    
    event AfterBuild(address indexed tokenAddress);
    event MultiBuild(address indexed asset, address indexed tokenAddress);
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
      emit AfterBuild(asset);
      _ass = asset;
      return asset;
    }

    function createTwo(address builder, string memory name, string memory symbol, address accessBuilder) public {
      Config memory _asset = Config(builder, name, symbol);
      Config memory _access = Config(accessBuilder, name, symbol);
      address asset = _create(_asset, _assetInterface);
      address access = _create(_access, _accessInterface);
      _parenting(asset, access);
      emit MultiBuild(asset, access);
    }

    function _create(Config memory _config, bytes4 _requiredInterface) private returns (address) {
      IAbstractFactory builder = IAbstractFactory(_config.builder);
      require(builder.canProduce(_requiredInterface), "Required Interface does not match");
      address target = builder.deploy(_config.name, _config.symbol);
      return target;
    }

    function _parenting(address asset, address access) private {
        IParent(asset).setChild(access);
        IChild(access).setParent(asset);
    }


    
    
    
  
}