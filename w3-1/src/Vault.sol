// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;


// import "std-interfaces";
import "solmate/utils/SafeTransferLib.sol";
import "./LYKToken.sol";

// interface IERC2612 is IERC20 {
//     function permit(
//         address owner,
//         address spender,
//         uint256 value,
//         uint256 deadline,
//         uint8 v,
//         bytes32 r,
//         bytes32 s
//     ) external virtual;
//     function DOMAIN_SEPARATOR() external view virtual returns (bytes32);
// }
// import "forge-std";
contract Vault {
    using SafeTransferLib for address;
    LYKToken immutable LYKT;
    mapping(address => uint) private accounts;
    error NotZero();
    error NotSuccess();
    error NotEnough();

    constructor(address lykt_address) {
        LYKT = LYKToken(lykt_address);
    }

    modifier BalanceNotZero() {
        if (accounts[msg.sender] == 0 wei) revert NotZero();
        _;
    }
    modifier AmountNotZero(uint amount) {
        if (0 == amount) revert NotZero();
        _;
    }
    modifier BalanceNotEnough(uint amount) {
        if (accounts[msg.sender] < amount) revert NotEnough();
        _;
    }

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        bool success = LYKT.transferFrom(msg.sender, address(this), msg.value);
        if(!success) revert NotSuccess();
        accounts[msg.sender] += msg.value;
    }

    function myBalance() external view returns (uint) {
        return accounts[msg.sender];
    }

    function withdraw(
        uint amount
    ) external AmountNotZero(amount) BalanceNotEnough(amount) {
        accounts[msg.sender] -= amount;
        try LYKT.transfer(msg.sender, amount) {} catch {
            revert NotSuccess();
        }
    }

}
