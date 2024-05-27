const { ethers } = require("hardhat");

const {
  getFactoryAddress,
  getRouterAddress,
  getTokenAddress,
  getTokenDecimals,
  getTokenInfo,
} = require("./static-data/getData.js");

/**
 * @notice All addresses in ETH layer 1.
 */

async function main() {
  const chainId = 1;
  const factoryAddress = await getFactoryAddress("uniswap", "v3", chainId);
  const baseToken = await getTokenAddress("WETH", chainId);
  const quoteToken = await getTokenAddress("USDC", chainId);
  console.log(`Factory: ${factoryAddress}`);
  const Arbitrage = await ethers.getContractFactory("ArbitrageV3");
  const arbitrage = await Arbitrage.deploy(
    factoryAddress,
    baseToken,
    quoteToken,
    500
  );

  const price = await arbitrage.estimateAmountOut(
    baseToken,
    ethers.parseEther("1"),
    10
  );
  console.log(`Price: ${price}`);
}

main();
