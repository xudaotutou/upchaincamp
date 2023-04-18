// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.13;
// import "v2-periphery/interfaces/IUniswapV2Router02.sol";
// import "forge-std/interfaces/IERC20.sol";

// create IUniswapV2Router02 from v2-periphery

// get a interface IERC20
// get a interface IER20 from forge-std

contract TokenMarket {
    IERC20 public immutable token;
    IUniswapV2Router02 public immutable router;

    constructor(address _token, address _router) {
        token = IERC20(_token);
        router = IUniswapV2Router02(_router);
    }

    // add liquidity token with invoking uniswaprouter
    function addLiquidityETH(uint amountTokenDesired, uint deadline)
        external
        payable
    {
        token.approve(address(router), amountTokenDesired);
        router.addLiquidityETH{value: msg.value}(
            address(token),
            amountTokenDesired,
            0,
            0,
            msg.sender,
            deadline
        );
    }
    // add buyToken
    function buyToken(uint deadline) external payable {
        address[] memory path = new address[](2);
        path[0] = router.WETH();
        path[1] = address(token);
        router.swapExactETHForTokens{value: msg.value}(
            0,
            path,
            msg.sender,
            deadline
        );
    } 
}

interface IER20 {
    function approve(address spender, uint256 amount) external returns (bool);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function balanceOf(address account) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function totalSupply() external view returns (uint256);

    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function name() external view returns (string memory);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

// get IUniswapV2Router02 from v2-periphery
interface IUniswapV2Router02 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    )
        external
        payable
        returns (
            uint amountToken,
            uint amountETH,
            uint liquidity
        );

    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);

    function swapExactETHForTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable returns (uint[] memory amounts);

    function swapTokensForExactETH(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapExactTokensForETH(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapETHForExactTokens(
        uint amountOut,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable returns (uint[] memory amounts);

    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function quote(
        uint amountA,
        uint reserveA,
        uint reserveB
    ) external pure returns (uint amountB);

    function getAmountOut(
        uint amountIn,
        uint reserveIn,
        uint reserveOut
    ) external pure returns (uint amountOut);

    function getAmountIn(
        uint amountOut,
        uint reserveIn,
        uint reserveOut
    ) external pure returns (uint amountIn);

    function getAmountsOut(uint amountIn, address[] calldata path)
        external
        view
        returns (uint[] memory amounts);

    function getAmountsIn(uint amountOut, address[] calldata path)
        external
        view
        returns (uint[] memory amounts);
}