const { ethers } = require("hardhat");
const { use, expect } = require("chai");
const { solidity } = require("ethereum-waffle");

use(solidity);

describe("AccessFactory", function () {
  let myContract;
  let owner;

  beforeEach(async function () {
    // Get the ContractFactory and Signers here.
    const YourContract = await ethers.getContractFactory("AccessFactory");

    // To deploy our contract, we just have to call Token.deploy() and await
    // for it to be deployed(), which happens onces its transaction has been
    // mined.
    [owner] = await ethers.getSigners();
    myContract = await YourContract.deploy();
  });

  describe("Corner cases", function () {
    it("Is abstract factory", async function () {
      expect(await myContract.supportsInterface(0x13bfaa22)).to.be.equal(true);
    });

    it("Should deploy", async function () {
      expect(await myContract.deploy("Test", "TST"));
    });

    it("Can produce Access", async function () {
      expect(await myContract.canProduce(0x78c1867b)).to.be.equal(true);
    });
  });
});
