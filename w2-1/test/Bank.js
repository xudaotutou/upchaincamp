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
    const [bank_signer, other1, other2] = await ethers.getSigners();

    const Bank = await ethers.getContractFactory("Bank");
    const bank = await Bank.deploy()
    // const acc0 = await new ethers.Wallet("0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199")
    // let balance = await acc0.getBalance()
    // console.log(balance)
    const acc1 = bank.connect(other1)
    const acc2 = bank.connect(other2)
    await acc2.deposit({ value: 2000 })
    return { other1, other2, acc1, acc2, bank };
  }
  describe("account", () => {
    it("存 0 元失败", async function () {
      const { acc1 } = await loadFixture(deployBank)
      await expect(acc1.deposit({ value: 0 })).to.be.revertedWithCustomError(acc1, "NotZero")
    });

    it("存成功 1000 ether", async function () {
      const { acc1 } = await loadFixture(deployBank)
      await acc1.deposit({ value: 1000 })
      expect(await acc1.balanceOf()).to.be.equal(1000)
    });
    it("存成功 1000 ether", async function () {
      const { acc1, other1, bank } = await loadFixture(deployBank)
      await expect(
        acc1.deposit({ value: 1000 })
      ).to.changeEtherBalances([bank, other1], [1000, -1000]);
      await expect(
        other1.sendTransaction({ to: bank.address, value: 1000 })
      ).to.changeEtherBalances([bank, other1], [1000, -1000]);
    })
  });
  it("转账失败 10000 ehter", async function () {
    const { acc2, other1 } = await loadFixture(deployBank)
    await expect(acc2.transferTo(await other1.getAddress(), 10000)).to.be.revertedWithCustomError(acc2, "NotEnough")

    await expect(acc2.transferTo(await other1.getAddress(), 0)).to.be.revertedWithCustomError(acc2, "NotZero")
  })
  it("转账成功 1000 ehter", async function () {
    const { acc1, acc2, other1, other2, bank } = await loadFixture(deployBank)
    await expect(acc2.transferTo(await other1.getAddress(), 1000)).to.changeEtherBalances([other1, other2, bank.address], [0, 0, 0])
    expect(await acc1.balanceOf()).to.be.equal(1000)
    expect(await acc2.balanceOf()).to.be.equal(1000)
  })
  it("取钱成功(全部)", async function () {
    const { acc2, other2, bank } = await loadFixture(deployBank)
    await expect(
      acc2.withdraw()
    ).to.changeEtherBalances([bank, other2], [-2000, 2000]);
  })
  it("取钱失败(全部)", async function () {
    const { acc1 } = await loadFixture(deployBank)
    await expect(acc1.withdraw()).to.be.revertedWithCustomError(acc1, "NotZero")
  })
  it("取钱 1000 失败(部分)", async function () {
    const { acc1, acc2 } = await loadFixture(deployBank)
    await expect(acc1.withdrawSome(1000)).to.be.revertedWithCustomError(acc1, "NotEnough")

    await expect(acc1.withdrawSome(0)).to.be.revertedWithCustomError(acc1, "NotZero")

    await expect(acc2.withdrawSome(100000)).to.be.revertedWithCustomError(acc1, "NotEnough")

    await expect(acc2.withdrawSome(0)).to.be.revertedWithCustomError(acc1, "NotZero")
  })
  it("取钱 1000 成功(部分)", async function () {
    const { acc1, acc2, bank, other2 } = await loadFixture(deployBank)
    await expect(acc2.withdrawSome(1000)).to.changeEtherBalances([bank, other2], [-1000, 1000])
    expect(await acc1.balanceOf()).to.be.equal(0)
    expect(await acc2.balanceOf()).to.be.equal(1000)
  })
})

