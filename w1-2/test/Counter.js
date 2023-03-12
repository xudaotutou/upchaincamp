const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");

describe("counter", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployCounter() {
    const [owner, otherAccount] = await ethers.getSigners();

    const Counter = await ethers.getContractFactory("Counter");
    const counter = await Counter.deploy();
    console.log("counter:" + counter.owner);
    return { counter, owner, otherAccount };
  }

  it("Owner call", async () => {
    const { counter } = await loadFixture(deployCounter);
    await counter.count();
    await counter.count()
    // expect(counter.val).not.to.be.reverted;
    expect(await counter.getVal()).to.be.equal(2)
  });
  it("Other call", async () => {
    const { counter, otherAccount } = await loadFixture(deployCounter);
    await expect( counter.connect(otherAccount).count()).to.be.revertedWith('error!');
    expect(await counter.getVal()).to.be.equal(0)
    // expect(counter.val).to.be.equal(1)
  })
})