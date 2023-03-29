// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { UUPSUpgradeable } from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenV0 is ERC20("v0","LTH"), UUPSUpgradeable, Ownable {
  function _authorizeUpgrade(address newImplementation) internal override onlyOwner() {}

  // _mint(msg.sender, 2 * 10 ** 18);
  function mint(uint amount)  external onlyOwner() {
    _mint(msg.sender, amount);
  }
}
