// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.20;

// import "@openzeppelin/contracts/interfaces/IERC20.sol";
// import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

// // WETH: 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2
// // USDC: 0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48

// // UniRouterV2: 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
// // SushiRouterV2: 0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F

// struct Dex {
//     address router;
// }

// contract ArbitrageV2 {
//     address public owner;
//     address public guardian;

//     address baseToken;
//     address quoteToken;
//     address exchangeARouterAddress;
//     address exchangeBRouterAddress;
//     IUniswapV2Router02 exchangeARouter;
//     IUniswapV2Router02 exchangeBRouter;

//     address USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
//     address WBTC = address(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599);
//     address WETH = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

//     address SushiRouterV2 = address(0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F);
//     address UniRouterV2 = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

//     constructor(
//         address _baseToken,
//         address _quoteToken,
//         address _exchangeARouter,
//         address _exchangeBRouter
//     ) {
//         owner = msg.sender;
//         baseToken = _baseToken;
//         quoteToken = _quoteToken;
//         exchangeARouterAddress = _exchangeARouter;
//         exchangeBRouterAddress = _exchangeBRouter;
//         exchangeARouter = IUniswapV2Router02(_exchangeARouter);
//         exchangeBRouter = IUniswapV2Router02(_exchangeBRouter);
//     }

//     modifier onlyOwner() {
//         require(msg.sender == owner, "[Not Owner]");
//         _;
//     }
//     modifier onlyGuardian() {
//         require(msg.sender == guardian, "[Not Owner]");
//         _;
//     }

//     function getNativeBalance() public view returns (uint256) {
//         return address(this).balance;
//     }
//     function getTokenBalance(
//         address _tokenAddress,
//         address _account
//     ) public view returns (uint256) {
//         IERC20 token = IERC20(_tokenAddress);
//         return token.balanceOf(_account);
//     }
//     // address _baseToken, address _quoteToken, address _routerAddress
//     function getQuote(
//         address baseTokenAddress,
//         address quoteTokenAddress,
//         address routerAddress
//     ) public view returns (uint256 price1, uint256 price2) {
//         address[] memory path = new address[](2);
//         path[0] = baseTokenAddress;
//         path[1] = quoteTokenAddress;
//         uint256 amountIn = 1 ether;
//         IUniswapV2Router02 router = IUniswapV2Router02(routerAddress);

//         uint[] memory amountOut = router.getAmountsOut(amountIn, path);

//         return (amountOut[0], amountOut[1]);
//     }

//     function checkDualSpread(
//         uint256 _decimals
//     ) public view returns (int256, int256) {
//         (, uint256 Aprice) = getQuote(
//             baseToken,
//             quoteToken,
//             exchangeARouterAddress
//         );
//         (, uint256 Bprice) = getQuote(
//             baseToken,
//             quoteToken,
//             exchangeBRouterAddress
//         );

//         int256 AtoBSpread = ((int256(Bprice) - int256(Aprice)) *
//             int256(10 ** _decimals)) / int256(Aprice);
//         int256 BtoASpread = ((int256(Aprice) - int256(Bprice)) *
//             int256(10 ** _decimals)) / int256(Bprice);
//         return (AtoBSpread, BtoASpread);
//     }

//     /**
//      *
//      * @notice Buy base/quote on Exchange A, sell quote/base on Exchange B.
//      * @param amountIn: The amount to initially swap. (In wei)
//      *
//      */
//     function swapAtoB(uint256 amountIn) private {
//         // Initialize objects for tokens to swap.
//         IERC20 _quoteToken = IERC20(quoteToken);
//         IERC20 _baseToken = IERC20(baseToken);

//         //2% increment
//         //uint256 increment = (amountIn * 2) / 100;
//         uint256 amountOutMin = 0;
//         /**----------------- Exchange A -----------------*/
//         // Check the current allowances.
//         uint256 quoteAllowance = _quoteToken.allowance(
//             address(this),
//             exchangeARouterAddress
//         );
//         if (quoteAllowance < amountIn) {
//             _quoteToken.approve(exchangeARouterAddress, type(uint256).max);
//         }

//         // Define the path for the swap: tokenIn -> tokenOut
//         address[] memory path1 = new address[](2);
//         path1[0] = quoteToken;
//         path1[1] = baseToken;

//         require(
//             getTokenBalance(quoteToken, address(this)) > 0,
//             "Balance of quoteToken is 0."
//         );

//         uint256 deadline = block.timestamp + 120; // Add a 2 minute deadline.

//         exchangeARouter.swapExactTokensForTokens(
//             amountIn,
//             amountOutMin,
//             path1,
//             address(this),
//             deadline
//         );
//         /**----------------- Exchange B -----------------*/

//         uint256 baseBalance = getTokenBalance(baseToken, address(this));
//         require(
//             baseBalance > 0,
//             "Balance of baseToken is 0. || First swap was not successful. "
//         );
//         uint256 baseAllowance = _baseToken.allowance(
//             address(this),
//             exchangeBRouterAddress
//         );
//         if (baseAllowance < baseBalance) {
//             _baseToken.approve(exchangeBRouterAddress, type(uint256).max); // Approve _baseToken on Exchange B.
//         }

//         // Define the path for the swap: base -> quote
//         address[] memory path2 = new address[](2);
//         path2[0] = baseToken;
//         path2[1] = quoteToken;

//         exchangeBRouter.swapExactTokensForTokens(
//             baseBalance,
//             amountOutMin,
//             path2,
//             address(this),
//             deadline
//         );
//     }
// }

// /* 
// WETH/USDC: 3739133205 -> 3739.133205     

// USDC/WETH: 14253557730117776727459

// WBTC/USDC: 72928511281 -> 72928.511281



// Sushi
// WETH/USDC: 3737552935 -> 3737.552935
        
// Uni
// WETH/USDC: 3740974855 -> 3740.974855
// */

// /**
//  *
//  * @notice
//  * @param
//  * @return
//  */
// /**
//  *
//  * @notice
//  * @param
//  * @return
//  */
// /**
//  *
//  * @notice
//  * @param
//  * @return
//  */
// /**
//  *
//  * @notice
//  * @param
//  * @return
//  */
// /**
//  *
//  * @notice
//  * @param
//  * @return
//  */
// /**
//  *
//  * @notice
//  * @param
//  * @return
//  */
