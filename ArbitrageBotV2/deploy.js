require("dotenv").config();
const { Data } = require("../Data/data.js");

PATH_TO_DATA = process.env.path_to_data;

async function main() {
  console.log(`Path: ${PATH_TO_DATA}`);
  const d = new Data(PATH_TO_DATA);
  console.log(d.baseDataPath);
  console.log(d.getFactoryAddress("uniswap", "v3", 1));
}

main();
