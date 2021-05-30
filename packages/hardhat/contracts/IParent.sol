// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './IChild.sol';

interface IParent {
  function setChild(IChild child) external;
}