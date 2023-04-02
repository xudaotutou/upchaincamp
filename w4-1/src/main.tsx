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
const { chains, provider, webSocketProvider } = configureChains(
  [sepolia],
  [
    // infuraProvider({ apiKey: "2c505fc9a84e4c4a9316de7e3efe97677" }),
    alchemyProvider({ apiKey: '92nK37m8wL340dCx_wTDPauSOnT9InON' }),
    publicProvider(),
  ],
)
const client = createClient(
  getDefaultClient({
    // autoConnect: true,
    appName: "Vault",
    chains,
    provider,
    webSocketProvider
  }),
);
ReactDOM.createRoot(document.getElementById('root') as HTMLElement).render(
  <React.StrictMode>
    <WagmiConfig client={client}>
      <ConnectKitProvider>
        <App />
      </ConnectKitProvider>
    </WagmiConfig>

  </React.StrictMode>,
)
