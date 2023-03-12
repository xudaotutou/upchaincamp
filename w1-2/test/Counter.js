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
    // await counter.count();
    expect(await counter.count()).not.to.be.reverted;
    // expect(await counter.val).to.be.equal(1)
  });
  it("Other call", async () => {
    const { counter, otherAccount } = await loadFixture(deployCounter);
    expect( counter.connect(otherAccount).count()).to.be.reverted;
    // expect(counter.val).to.be.equal(1)
  })
})