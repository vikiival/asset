const { ethers } = require("hardhat");
const { use, expect } = require("chai");
const { solidity } = require("ethereum-waffle");

use(solidity);

describe("BadgeManager", function () {
  let myContract;
  let owner;

  beforeEach(async function () {
    // Get the ContractFactory and Signers here.
    const YourContract = await ethers.getContractFactory("BadgeManager");

    // To deploy our contract, we just have to call Token.deploy() and await
    // for it to be deployed(), which happens onces its transaction has been
    // mined.
    [owner] = await ethers.getSigners();
    myContract = await YourContract.deploy("KKT", "ABC");
  });

  describe("Corner cases", function () {
    it("Should have actual zero tokens", async function () {
      expect(await myContract.actualTokenId()).to.equal(0);
    });

    it("Should mint", async function () {
      await myContract.create("A", 256, 8);
      expect(await myContract.actualTokenId()).to.equal(1);

      expect(await myContract.getScore(1)).to.equal(8);

      expect(await myContract.getStake(1)).to.equal(256);
    });

    it("Should obtain", async function () {
      await myContract.create("A", 256, 8);
      expect(await myContract.actualTokenId()).to.equal(1);
      // eslint-disable-next-line no-underscore-dangle
      expect(await myContract._scores[owner.address]).to.equal(undefined);
      await myContract.obtain(owner.address, 1);
      // expect(await myContract.obtain(owner.address, 1)).not.to.throw();
      // eslint-disable-next-line no-underscore-dangle
      // expect(await myContract._scores[owner.address]).to.equal(8);
    });

    it("Should revoke", async function () {
      await myContract.create("A", 256, 8);
      expect(await myContract.actualTokenId()).to.equal(1);
      // eslint-disable-next-line no-underscore-dangle
      try {
        // eslint-disable-next-line no-underscore-dangle
        await myContract._revoke(owner.address, 1);
      } catch (e) {
        expect(e.message).to.be.equal(
          "VM Exception while processing transaction: revert ERC721: Cannot _revoke badge from address"
        );
      }
      // expect(await myContract.obtain(owner.address, 1)).not.to.throw();
      // eslint-disable-next-line no-underscore-dangle
      // expect(await myContract._scores[owner.address]).to.equal(8);
    });
  });
});
