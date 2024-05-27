const fs = require("fs");

class Data {
  baseDataPath;
  tokensPath;
  dexPath;
  constructor(PATH_TO_DATA) {
    this.baseDataPath = `${PATH_TO_DATA}\\static-data`;
    this.tokensPath = `${this.baseDataPath}\\tokens`;
    this.dexPath = `${this.baseDataPath}\\dexs`;
  }

  async getFactoryAddress(dexName, dexVersion, chainId) {
    console.log(`Base: ${this.baseDataPath}   
                 Toekens: ${this.tokensPath}
                 DEXs: ${this.dexPath}`);
    const filePath = `${this.dexPath}\\dexs.json`;
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
  /**
   * @param {string} dexName
   * @param {string} dexVersion
   * @param {Number} chainId
   * @returns {string} address of dex router.
   */
  async getRouterAddress(dexName, dexVersion, chainId) {
    const filePath = `${this.dexPath}\\dexs.json`;
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
  /**
   * @param {string} tokenSymbol:
   * @param {Number} chainId:
   * @returns {string} address of token.
   */
  async getTokenAddress(tokenSymbol, chainId) {
    const filePath = `${this.tokensPath}\\tokens.json`;
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
  /**
   * @param {string} tokenSymbol:
   * @param {Number} chainId:
   * @returns {string} address of token.
   */
  async getTokenDecimals(tokenSymbol, chainId) {
    const filePath = `${this.tokensPath}\\tokens.json`;
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
  /**
   * @param {string} tokenSymbol:
   * @param {Number} chainId:
   * @returns {JSON} Key information about the token such as address & decimals..
   */
  async getTokenInfo(tokenSymbol, chainId) {
    const filePath = `${this.tokensPath}\\tokens.json`;
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
}

module.exports = {
  Data,
};
