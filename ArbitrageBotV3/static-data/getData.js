const fs = require("fs");

async function getFactoryAddress(dexName, dexVersion, chainId) {
  const filePath = `static-data\\dexs\\dexs.json`;
  const data = fs.readFileSync(filePath, "utf-8");
  const jsonData = JSON.parse(data);

  try {
    const routerAddress =
      jsonData[dexName][dexVersion][chainId]["factoryAddress"];
    return routerAddress;
  } catch (e) {
    console.log(`[getRouterAddress() Error]: ${e}`);
    return "null";
  }
}

async function getRouterAddress(dexName, dexVersion, chainId) {
  const filePath = `static-data\\dexs\\dexs.json`;
  const data = fs.readFileSync(filePath, "utf-8");
  const jsonData = JSON.parse(data);

  try {
    const routerAddress =
      jsonData[dexName][dexVersion][chainId]["routerAddress"];
    return routerAddress;
  } catch (e) {
    console.log(`[getRouterAddress() Error]: ${e}`);
    return "null";
  }
}

async function getTokenAddress(tokenSymbol, chainId) {
  const filePath = `static-data\\tokens\\tokens.json`;
  const data = fs.readFileSync(filePath, "utf-8");
  const jsonData = JSON.parse(data);

  try {
    const tokenAddress = jsonData[chainId][tokenSymbol]["address"];
    return tokenAddress;
  } catch (e) {
    console.log(`[getTokenAddress() Error]: ${e}`);
    return "null";
  }
}

async function getTokenDecimals(tokenSymbol, chainId) {
  const filePath = `static-data\\tokens\\tokens.json`;
  const data = fs.readFileSync(filePath, "utf-8");
  const jsonData = JSON.parse(data);

  try {
    const tokenDecimals = jsonData[chainId][tokenSymbol]["decimals"];
    return tokenDecimals;
  } catch (e) {
    console.log(`[getTokenDecimals() Error]: ${e}`);
    return "null";
  }
}

async function getTokenInfo(tokenSymbol, chainId) {
  const filePath = `static-data\\tokens\\tokens.json`;
  const data = fs.readFileSync(filePath, "utf-8");
  const jsonData = JSON.parse(data);

  try {
    const tokenInfo = jsonData[chainId][tokenSymbol];
    return tokenInfo;
  } catch (e) {
    console.log(`[getTokenInfo() Error]: ${e}`);
    return "null";
  }
}

module.exports = {
  getFactoryAddress,
  getRouterAddress,
  getTokenAddress,
  getTokenDecimals,
  getTokenInfo,
};
