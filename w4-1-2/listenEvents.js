import { ethers, Contract, Interface, JsonRpcProvider, InfuraProvider } from "ethers";
import { abi as erc721abi, address } from "./abi/erc721.js"

export async function main(db) {

  let provider = new JsonRpcProvider('https://sepolia.infura.io/v3/2c505fc9a84e4c4a9316de7e3efe9767', 'sepolia')
  let myerc721 = new Contract(address, erc721abi, provider)

  myerc721.on("Transfer", async (from, to, token) => {
    console.log("!!!")
    console.log(from, to, token)
    const result = await db.run(
      'INSERT INTO erc721_logs ("from", "to", "tokenId") VALUES (?,?,?)',
      from,
      to,
      token.toString()
    )
  })
  console.log(db)
}

// main()
