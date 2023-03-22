// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// import "./LYKToken.sol";
import "solmate/tokens/ERC20";
import "solmate/utils/SafeTransferLib.sol";

// interface IERC4626 {
//     function asset() external view returns (address);

//     function totalAssets() external view returns (uint256);

//     function convertToShares(
//         uint256 assets
//     ) external view returns (uint256 shares);

//     function convertToAssets(
//         uint256 shares
//     ) external view returns (uint256 assets);

//     function maxDeposit(address receiver) external view returns (uint256);

//     function previewDeposit(uint256 assets) external view returns (uint256);

//     function deposit(
//         uint256 assets,
//         address receiver
//     ) external returns (uint256 shares);

//     function maxMint(address receiver) external view returns (uint256);

//     function previewMint(uint256 shares) external view returns (uint256);

//     function mint(
//         uint256 shares,
//         address receiver
//     ) external returns (uint256 assets);

//     function maxWithdraw(address owner) external view returns (uint256);

//     function previewWithdraw(uint256 assets) external view returns (uint256);

//     function withdraw(
//         uint256 assets,
//         address receiver,
//         address owner
//     ) external returns (uint256 shares);

//     function maxRedeem(address owner) external view returns (uint256);

//     function previewRedeem(uint256 shares) external view returns (uint256);

//     function redeem(
//         uint256 shares,
//         address receiver,
//         address owner
//     ) external returns (uint256 assets);

//     function totalSupply() external view returns (uint256);

//     function balanceOf(address owner) external view returns (uint256);

//     event Deposit(
//         address indexed sender,
//         address indexed owner,
//         uint256 assets,
//         uint256 shares
//     );
//     event Withdraw(
//         address indexed sender,
//         address indexed receiver,
//         address indexed owner,
//         uint256 assets,
//         uint256 share
//     );
// }
// import "forge-std";
contract Vault is ERC20 {
    using SafeTransferLib for address;

    mapping(address => uint) private accounts;
    error NotZero();
    error NotSuccess();
    error NotEnough();

    constructor() ERC20("LYKT", "LH", 18) {
        _mint(address(this), 100000 * 10 ** 18);
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

    function deposit() external payable AmountNotZero(msg.value) {
        accounts[msg.sender] += msg.value;
    }

    function myBalance() external view returns (uint) {
        return accounts[msg.sender];
    }

    function withdrawSome(
        uint amount
    ) external AmountNotZero(amount) BalanceNotEnough(amount) {
        accounts[msg.sender] -= amount;
        try msg.sender.safeTransferETH(amount) {} catch {
            revert NotSuccess();
        }
    }

    function withdraw() external BalanceNotZero {
        uint amount = accounts[msg.sender];
        accounts[msg.sender] = 0;
        try msg.sender.safeTransferETH(amount) {} catch {
            revert NotSuccess();
        }
    }
}
