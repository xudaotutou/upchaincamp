require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config({
  path:'./.env'
})
/** @type import('hardhat/config').HardhatUserConfig */
// console.log(process.env)
module.exports = {
  solidity: "0.8.17",
  networks: {
    goerli: {
      url: `https://eth-goerli.alchemyapi.io/v2/${process.env.ALCHEMY_API_KEY}`,
      accounts: [process.env.GOERLI_PRIVATE_KEY]
    },
    ganache:{
      url: `http://127.0.0.1:8545`,
      accounts:[process.env.GANACHE_PRIVATE_KEY]
    }
  },
  etherscan: {
    apiKey:{
      goerli: process.env.ETHERSCAN_API_KEY,
      ganache: process.env.GANACHE_API_KEY
    }
  }

};
