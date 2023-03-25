// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IERC2612 is IERC20, IERC20Permit {}

contract LYKTItemMaket is IERC721Receiver {
  mapping(uint => uint) public tokenIdPrice;

  IERC2612 public immutable token;
  IERC721 public immutable nftToken;

  constructor(address _token, address _nftToken) {
    token = IERC2612(_token);
    nftToken = IERC721(_nftToken);
  }

  function onERC721Received(
    address operator,
    address from,
    uint256 tokenId,
    bytes calldata data
  ) external pure override returns (bytes4) {
    return this.onERC721Received.selector;
  }

  function list(uint tokenId, uint amount) external {
    require(tokenIdPrice[tokenId] == 0, "already exist");
    nftToken.safeTransferFrom(msg.sender, address(this), tokenId, "");
    tokenIdPrice[tokenId] += amount;
  }
  function balanceOf(uint tokenId) public view returns (uint) {
    return tokenIdPrice[tokenId];
  }
  function buy(uint tokenId, uint amount) external {
    require(tokenIdPrice[tokenId] != 0, "not exist");
    require(amount >= tokenIdPrice[tokenId], "low price");
    require(nftToken.ownerOf(tokenId) == address(this), "aleady selled");

    token.transferFrom(msg.sender, address(this), tokenIdPrice[tokenId]);
    nftToken.safeTransferFrom(address(this), msg.sender, tokenId);
  }
}
