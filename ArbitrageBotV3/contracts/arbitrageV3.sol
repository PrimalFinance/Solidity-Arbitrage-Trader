// SPDX-License-Identifier: MIT
pragma solidity 0.7.6;

import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "@uniswap/v3-periphery/contracts/libraries/OracleLibrary.sol";

contract ArbitrageV3 {
    address public baseToken;
    address public quoteToken;
    address public pool;

    constructor(
        address _factory,
        address _baseToken,
        address _quoteToken,
        uint24 _fee
    ) {
        baseToken = _baseToken;
        quoteToken = _quoteToken;
        address _pool = IUniswapV3Factory(_factory).getPool(
            _baseToken,
            _quoteToken,
            _fee
        );
        require(_pool != address(0), "Invalid Pool");
    }

    function estimateAmountOut(
        address tokenIn,
        uint128 amountIn,
        uint32 secondsAgo
    ) external view returns (uint amountOut) {
        require(tokenIn == baseToken || tokenIn == quoteToken, "Invalid Token");
        // If tokenIn = baseToken, tokenOut = quoteToken, Else tokenOut = baseToken.
        address tokenOut = tokenIn == baseToken ? quoteToken : baseToken;
        uint32[] memory secondsAgos = new uint32[](2);
        secondsAgos[0] = secondsAgo;
        secondsAgos[1] = 0;

        (int56[] memory tickCumulatives, ) = IUniswapV3Pool(pool).observe(
            secondsAgos
        );
        int56 tickCumulativesDelta = tickCumulatives[1] - tickCumulatives[0];
        int24 tick = int24(tickCumulativesDelta / secondsAgo);
        // Always round to negative infinity.
        if (
            tickCumulativesDelta < 0 && (tickCumulativesDelta % secondsAgo != 0)
        ) {
            tick--;
        }
        amountOut = OracleLibrary.getQuoteAtTick(
            tick,
            amountIn,
            tokenIn,
            tokenOut
        );

        amountOut = OracleLibrary.getQuoteAtTick(
            tick,
            amountIn,
            tokenIn,
            tokenOut
        );
    }
}
