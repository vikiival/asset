const { ethers } = require("hardhat");
const { use, expect } = require("chai");
const { solidity } = require("ethereum-waffle");

use(solidity);

const unwrap = async (tx) => {
  const data = await tx.wait();
  const addr = data.events
    .filter(({ event }) => event === "AfterBuild")
    .map(({ args }) => args[0]);
  return addr[0];
};

describe("Factory", function () {
  let myContract;
  let owner;
  let assetFactory;
  let accessFactory;

  beforeEach(async function () {
    // Get the ContractFactory and Signers here.
    const YourContract = await ethers.getContractFactory("Factory");
    const Asset = await ethers.getContractFactory("AssetFactory");

    // To deploy our contract, we just have to call Token.deploy() and await
    // for it to be deployed(), which happens onces its transaction has been
    // mined.
    [owner] = await ethers.getSigners();
    myContract = await YourContract.deploy();
    assetFactory = await Asset.deploy();
  });

  describe("Main", function () {
    it("Can Create asset", async function () {
      const tx = await myContract.create(assetFactory.address, "Name", "SYM");
      const addr = await unwrap(tx);

      const myAsset = await ethers.getContractAt("Asset", addr);
      expect(await myAsset.owner()).to.be.equal(myContract.address);
    });
  });
});
