// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface Icb {
  function depositWithAddress(address, uint256) external;
}
import { ERC20 } from "solmate/tokens/ERC20.sol";

contract LYKToken is ERC20 {
  constructor() ERC20("LYKT", "LH", 18) {
    // 发行 100, 000个token
    _mint(msg.sender, 100000 * 10 ** 18);
  }
  // 用了回调的版本
  function deposit(address vault, uint amount) external returns(bool){
    bool success = transfer(vault, amount);
    if(!success) return false;
    try Icb(vault).depositWithAddress(msg.sender, amount) {} catch  {
      return false;
    }
    return true;
  }
}
