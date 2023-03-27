// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { UUPSUpgradeable } from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";

interface TokenRecipient {
  function tokensReceived(address sender, uint amount) external returns (bool);
}

contract TokenV1 is ERC20("v1", "LTH"), UUPSUpgradeable, Ownable {
  constructor() {}
  using Address for address;
  function _authorizeUpgrade(
    address newImplementation
  ) internal override onlyOwner {}

  function mint(uint amount) external onlyOwner {
    _mint(msg.sender, amount);
  }

  function transferWithCallback(
    address recipient,
    uint256 amount
  ) external returns (bool) {
    _transfer(msg.sender, recipient, amount);

    if (recipient.isContract()) {
      bool rv = TokenRecipient(recipient).tokensReceived(msg.sender, amount);
      require(rv, "No tokensReceived");
    }
    return true;
  }
}
