import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
// import './index.css'
import { WagmiConfig, configureChains, createClient, mainnet } from 'wagmi'
import { publicProvider } from 'wagmi/providers/public'
import { ConnectKitProvider, getDefaultClient } from 'connectkit'
import { sepolia } from 'wagmi/chains'
import { infuraProvider } from 'wagmi/providers/infura'
import { alchemyProvider } from 'wagmi/providers/alchemy'
const apiKey = import.meta.env.VITE_INFURAID_ID;
// console.log(infuraId)
// const localhost = {
//   id: 31337,
//   name: "Localhost",
//   network: "localhost",
//   nativeCurrency: {
//     decimals: 18,
//     name: "Ether",
//     symbol: "GO",
//   },
//   rpcUrls: {
//     default: {
//       http: ["http://127.0.0.1:8545"]
//     },
//     public: {
//       http: ["http://127.0.0.1:8545"]
//     }
//   }
// };

// connet to sepolia testnet with wagmi get chains, provider
const {chains, provider} = configureChains([sepolia], [infuraProvider({apiKey}), alchemyProvider({apiKey}), publicProvider()])

// create client with createClient
const client = createClient(getDefaultClient({appName: "Vault", chains, provider}))

ReactDOM.createRoot(document.getElementById('root') as HTMLElement).render(
  <React.StrictMode>
    <WagmiConfig client={client}>
      <ConnectKitProvider>
        <App />
      </ConnectKitProvider>
    </WagmiConfig>

  </React.StrictMode>,
)
