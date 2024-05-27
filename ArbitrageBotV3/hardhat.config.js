require("dotenv").config();
require("@nomicfoundation/hardhat-toolbox");

const PRIVATE_KEY1 = process.env.PRIVATE_KEY1;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.7.6",
      },
    ],
    overrides: {
      "contracts/arbitrageV3.sol": {
        version: "0.7.6",
      },
    },
  },
  networks: {
    hardhat: {
      forking: {
        url: process.env.INFURA_ETHEREUM_URL,
      },
    },

    // --------------------- Arbitrum
    arbitrum: {
      url: process.env.ARBITRUM_RPC_URL,
      chainId: 42161,
      accounts: [PRIVATE_KEY1], // PRIVATE KEY 1 is invalid.
      blockConfirmations: 6,
    },
    ethereum: {
      url: process.env.ETHEREUM_RPC_URL,
      chainId: 1,
      accounts: [PRIVATE_KEY1],
      blockConfirmations: 2,
    },
    // --------------------- Optimism
    optimism: {
      url: process.env.OPTIMISM_RPC_URL,
      chaindId: 10,
      accounts: [PRIVATE_KEY1],
      blockConfirmations: 6,
    },
    // --------------------- Optimism
    polygon: {
      url: process.env.POLYGON_RPC_URL,
      chainId: 137,
      accounts: [PRIVATE_KEY1],
      blockConfirmations: 6,
    },
    sepolia: {
      url: process.env.SEPOLIA_RPC_URL,
      chainId: 11155111,
      accounts: [process.env.wallet_key],
      blockConfirmations: 2,
    },
  },
};
