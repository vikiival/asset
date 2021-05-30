// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './IParent.sol';

interface IChild {
  function setParent(IParent parent) external;
}