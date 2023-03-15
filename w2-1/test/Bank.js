const {
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Bank", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployBank() {

    // Contracts are deployed using the first signer/account by default
    const [bank_address, other1, other2] = await ethers.getSigners();

    const Bank = await ethers.getContractFactory("Bank");
    const bank = await Bank.deploy();
    other1.ba
    const acc1 = bank.connect(other1)
    const acc2 = bank.connect(other2)
    return { other1, acc1, acc2 };
  }
  describe("account1", () => {
    it("存 0 元", async function () {
      const { acc1 } = await loadFixture(deployBank)
      await expect(acc1.deposit({ value: 0 })).to.be.revertedWith(
        "save too less"
      );
    });

    it("存成功 1 ether", async function () {
      const { acc1 } = await loadFixture(deployBank)
      await acc1.deposit({ value: 1 })
      expect(await acc1.balanceOf()).to.be.equal(1)
    });
    it("取钱1ether失败", async function () {
      const { acc1 } = await loadFixture(deployBank)
      await expect(acc1.withdraw()).to.be.revertedWith("withdraw too more")
    })
    it("取钱1ether成功", async function () {
      const { acc1, other1 } = await loadFixture(deployBank)
      await acc1.deposit({ value: 1 })
      expect(await acc1.balanceOf()).to.be.equal(1)
      await acc1.withdraw()
      expect(await acc1.balanceOf()).to.be.equal(0)
    })
  })
  // describe("account2", async function () {
  //   const { bank, other1, other2 } = await loadFixture(deployBank)
  //   let acc1 = bank.connect(other1)
  //   // let acc2 = bank.connect(other2)
  //   it("存 0 元", async function () {
  //     await expect(acc1.deposit({ value: 0 })).to.be.revertedWith(
  //       "save too less"
  //     );
  //   });

  //   it("存成功1ether", async function () {
  //     await acc1.deposit({ value: 1 })
  //     expect(await acc1.balanceOf()).to.be.equal(1)
  //     // expect(await acc2.balanceOf()).to.be.equal(0)
  //   });
  //   it("取钱1ether成功", async function () {
  //     expect(await acc1.withdraw()).to.be.equal(1)
  //     // expect(await acc1.withdraw()).to.be.revertedWith("withdraw too more")
  //     // expect(await acc2.balanceOf()).to.be.equal(0)
  //   })
  // });

});
