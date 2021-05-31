const { ethers } = require("hardhat");
const { use, expect } = require("chai");
const { solidity } = require("ethereum-waffle");

use(solidity);

const unwrap = async (tx, e = "AfterBuild", cb = ({ args }) => args[0]) => {
  const data = await tx.wait();
  const addr = data.events.filter(({ event }) => event === e).map(cb);
  return addr[0];
};

describe("Factory", function () {
  let myContract;
  let owner;
  let assetFactory;
  let accessFactory;
  let addr1;
  let addr2;

  beforeEach(async function () {
    // Get the ContractFactory and Signers here.
    const YourContract = await ethers.getContractFactory("Factory");
    const Asset = await ethers.getContractFactory("AssetFactory");
    const Access = await ethers.getContractFactory("AccessFactory");

    // To deploy our contract, we just have to call Token.deploy() and await
    // for it to be deployed(), which happens onces its transaction has been
    // mined.
    [owner, addr1, addr2] = await ethers.getSigners();
    myContract = await YourContract.deploy();
    assetFactory = await Asset.deploy();
    accessFactory = await Access.deploy();
  });

  describe("Main", function () {
    it("Can Create asset", async function () {
      const tx = await myContract.create(assetFactory.address, "Name", "SYM");
      const addr = await unwrap(tx);

      const myAsset = await ethers.getContractAt("Asset", addr);
      expect(await myAsset.owner()).to.be.equal(myContract.address);
    });
  });

  describe("App", async function () {
    it("Asset rent lifecycle", async function () {
      const tx = await myContract.createTwo(
        assetFactory.address,
        "Name",
        "SYM",
        accessFactory.address
      );

      const [ass, acc] = await unwrap(tx, "MultiBuild", ({ args }) => [
        args[0],
        args[1],
      ]);

      const myAsset = await ethers.getContractAt("Asset", ass);
      const myAccess = await ethers.getContractAt("Access", acc);
      expect(await myAsset.isParentFor()).to.be.equal(myAccess.address);
      await myAsset.create("");
      expect(await myAsset.currentId()).to.be.equal(1);
      expect(await myAccess.currentId()).to.be.equal(1);
      await myAsset.masterAccess(1, addr1.address);
      expect(await myAccess.currentId()).to.be.equal(2);
      await myAsset.connect(addr2).rent(1, 15);
      expect(await myAccess.currentId()).to.be.equal(3);
      expect(await myAsset.isAvailable(1)).to.be.equal(false);
      expect(await myAccess.accessPeriod(3)).to.be.equal(900);
      expect(await myAccess.assetFor(3)).to.be.equal(1);
      expect(await myAccess.ownerOf(3)).to.be.equal(addr2.address);
      await myAsset.connect(addr2).finish(1);

      try {
        await myAccess.accessPeriod(3);
      } catch (e) {
        expect(e.message).to.be.equal(
          "VM Exception while processing transaction: revert ERC721: operator query for nonexistent token"
        );
      }
    });
  });
});
