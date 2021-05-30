// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
// import  '@openzeppelin/contracts/utils/Counters.sol';
// import  '@openzeppelin/contracts/utils/introspection/IERC165.sol';
import './Asset.sol';
import './IAbstractFactory.sol';
import './IAsset.sol';

contract AssetFactory is IERC165, IAbstractFactory {
    // using Counters for Counters.Counter;
    // Counters.Counter private _serviceCounter;

    
    // mapping(uint256 => bool) private _availableServices;
    
    event AfterBuild(address tokenAddress);

    constructor() public {
        // factory = Factory(_factoryAddr);
    }
  
    function deploy(string memory name, string memory symbol) public override returns (address) {
        // address ownerAddress = msg.sender;
        Asset asset = new Asset(name, symbol, msg.sender);
        // Approval approval = new Approval(name, symbol, address(this));
        // asset.setChild(approval);
        // approval.setParent(asset);
        return address(asset);
        
    }
     
    function canProduce(bytes4 interfaceId) public view override returns (bool) {
        return interfaceId == type(IAsset).interfaceId;
    }

    function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
        return interfaceId == type(IAbstractFactory).interfaceId;
    }
}