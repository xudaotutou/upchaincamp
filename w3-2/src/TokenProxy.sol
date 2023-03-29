// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;
// import "@openzeppelin/contracts/proxy/Proxy.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenProxy is ERC20, ERC1967Proxy, Ownable{
  constructor(address token) Ownable() ERC20("LYKT","LTH") ERC1967Proxy(token,""){}
}
