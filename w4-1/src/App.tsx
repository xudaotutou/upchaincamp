import { ConnectKitButton } from "connectkit";
import { Address, useAccount, useContractWrite, useContractRead, useSigner, useWaitForTransaction, usePrepareContractWrite, useSignTypedData, usePrepareSendTransaction, UseContractWriteConfig, useNetwork } from "wagmi";
import { prepareWriteContract, writeContract, PrepareWriteContractResult, SendTransactionResult } from 'wagmi/actions'
import { abi as vault } from "./abi/vault"
import { abi as erc20 } from './abi/erc20'
import { useState } from "react";
import { BigNumber, Contract, ethers, utils } from "ethers";
import useDebounce from "./hooks/useDebounce";
// const vaultAddress = '0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512' as const
// const erc20Address = '0x5FbDB2315678afecb367f032d93F642f64180aa3' as const
const vaultAddress = '0x466125BE88E92645AdE935729477f70249423dAB' as const
const erc20Address = '0xfF4a2a217730F40986cE9aa7d14Bc39F50295ba3' as const
const ERC20BalanceOf = () => {
  const { address } = useAccount()
  const { data: balance, isSuccess } = useContractRead({ address: erc20Address, abi: erc20, functionName: 'balanceOf', args: [address!], watch: true })
  return <div>erc20_Balance: {balance?.toString()} LTH</div>
}
const VaultBalance = () => {
  const { address } = useAccount()
  const { data: balance, isSuccess } = useContractRead({ address: erc20Address, abi: erc20, functionName: 'balanceOf', args: [vaultAddress], watch: true })
  return <div>vault_total_Balance: {balance?.toString()} LTH</div>
}
const VaultBalanceOf = () => {
  const { data: balance, isSuccess } = useContractRead({ address: vaultAddress, abi: vault, functionName: 'balanceOf', watch: true })
  return <div>vault_Balance: {balance?.toString()} LTH</div>
}

const Approve = () => {
  const [amount, setAmount] = useState('')
  const debounceAmount = useDebounce(amount)
  const { config, isError: isPreError, error: preError } = usePrepareContractWrite({
    address: erc20Address,
    abi: erc20,
    functionName: "approve",
    args: amount ? [vaultAddress, BigNumber.from(debounceAmount)] : undefined,
    enabled: Boolean(debounceAmount),
    // overrides
  })
  const { data, write } = useContractWrite(config)
  const { isSuccess, isError, error, isLoading, status } = useWaitForTransaction({
    hash: data?.hash
  })
  return (
    <div>
      approve:
      <input
        onChange={(e) => setAmount(e.target.value)}
        placeholder="amount (in wei)"
        value={amount}
      />
      <button disabled={!write || isLoading} onClick={() => write?.()}>
        approve
      </button>
      {status}
      {isSuccess && <div>success!</div>}
      {isPreError && <div>{preError?.message}</div>}
      {isError && <div>{error?.message}</div>}
    </div>
  )
}
const Deposit = () => {
  const [amount, setAmount] = useState('')
  const debounceAmount = useDebounce(amount)
  const { config, error: preErr, isError: isPreErr } = usePrepareContractWrite({
    address: vaultAddress,
    abi: vault,
    functionName: "deposit",
    args: debounceAmount ? [BigNumber.from(debounceAmount)] : undefined,
    enabled: !!debounceAmount,
    overrides: {
      gasLimit: BigNumber.from(130000)
    }
  })
  const { data, write } = useContractWrite(config)

  const { isSuccess, status, isLoading, isError, error } = useWaitForTransaction({
    hash: data?.hash,
  })

  return (
    <div>
      deposit:{''}
      <input
        onChange={(e) => setAmount(e.target.value)}
        placeholder="amount (in wei)"
        value={amount}
      />
      <button onClick={(e) => {
        e.preventDefault()
        write?.()
      }} disabled={!write || isLoading}>
        deposit!
      </button>
      {isSuccess && <div>Success!</div>}
      {isLoading && status}
      {isPreErr && <div>preError: {preErr?.message}</div>}
      {isError && <div>Error: {error?.message}</div>}

    </div>
  )
}
const Allownce = () => {
  const { address: owner } = useAccount()
  const { data: allownce, isSuccess } = useContractRead({
    address: erc20Address,
    abi: erc20,
    functionName: 'allowance',
    args: [owner!, vaultAddress],
    watch: true
  })
  return <div>allownce: {allownce?.toString()} LTH</div>
}
const WidthDraw = () => {
  const [amount, setAmount] = useState('')
  const debounceAmount = useDebounce(amount)
  const { config, error: preErr, isError: isPreErr } = usePrepareContractWrite({
    address: vaultAddress,
    abi: vault,
    functionName: "withdraw",
    args: debounceAmount ? [BigNumber.from(debounceAmount)] : undefined,
    enabled: !!debounceAmount,
    overrides: {
      gasLimit: BigNumber.from(130000)
    }
  })
  const { data, write } = useContractWrite(config)

  const { isSuccess, status, isLoading, isError, error } = useWaitForTransaction({
    hash: data?.hash,
  })

  return (
    <div>
      WidthDraw:{''}
      <input
        onChange={(e) => setAmount(e.target.value)}
        placeholder="amount (in wei)"
        value={amount}
      />
      <button onClick={(e) => {
        e.preventDefault()
        write?.()
      }} disabled={!write || isLoading}>
        WidthDraw!
      </button>
      {isSuccess && <div>Success!</div>}
      {isLoading && status}
      {isPreErr && <div>preError: {preErr?.message}</div>}
      {isError && <div>Error: {error?.message}</div>}

    </div>
  )
}
const Permit = () => {
  const { address: owner } = useAccount()
  const { chain } = useNetwork()
  const [amount, setAmount] = useState('')
  const [deadline, setDeadline] = useState('')
  const [tx, setTx] = useState<SendTransactionResult>()
  const debounceAmount = useDebounce(amount)
  const { data: nonce } = useContractRead({ abi: erc20, address: erc20Address, functionName: 'nonces', watch: true, args: [owner!] })

  const domain = {
    name: 'LYKToken',
    version: '1',
    verifyingContract: erc20Address,
    chainId: chain?.id
  }

  const types = {
    Permit: [
      { name: "owner", type: "address" },
      { name: "spender", type: "address" },
      { name: "value", type: "uint256" },
      { name: "nonce", type: "uint256" },
      { name: "deadline", type: "uint256" }
    ]
  } as const

  const { isError: isSignError, signTypedDataAsync } =
    useSignTypedData({
      domain,
      types,
    })
  const { isSuccess, isError, data, isLoading, status, error } = useWaitForTransaction({
    hash: tx?.hash
  })
  const depositWithPermit = async () => {
    const deadline = BigNumber.from(Math.floor(Date.now() / 1000) + 3600)
    const value = BigNumber.from(debounceAmount)
    const signature = await signTypedDataAsync({
      value: {
        owner: owner!,
        spender: vaultAddress,
        value,
        nonce: BigNumber.from(nonce),
        deadline
      }
    })
    console.log(signature, owner, value, nonce, deadline)
    const { r, s, v } = utils.splitSignature(signature)
    console.log(v, r, s, deadline, value)
    const config = await prepareWriteContract({
      abi: vault,
      address: vaultAddress,
      functionName: 'depositWithPermit',
      args: [value, deadline, v, r as `0x${string}`, s as `0x${string}`],
      overrides: {
        gasLimit: BigNumber.from(1000000)
      }
    })

    const tx = await writeContract(config)
    setTx(tx)
  }
  return (
    <div>
      <input
        onChange={(e) => setAmount(e.target.value)}
        placeholder="amount (in wei)"
        value={amount}
      />
      <button disabled={!amount || !nonce || isLoading} onClick={e => {
        e.preventDefault()
        depositWithPermit()
      }}>
        depositWithPermit
      </button>
      {status}
      {isError && <div>{error?.message}</div>}
    </div>
  )
}
const Vault = () => {
  const { isConnected } = useAccount()
  return (
    <div>
      <h2>vault</h2>
      <div>Contract Address: {vaultAddress}</div>

      {isConnected && <>
        <ERC20BalanceOf></ERC20BalanceOf>
        <VaultBalance></VaultBalance>
        <VaultBalanceOf></VaultBalanceOf>
        <Allownce></Allownce>
        <Approve></Approve>
        <Deposit></Deposit>
        <WidthDraw></WidthDraw>
        <Permit></Permit>
      </>}
    </div>
  )
}
// 怎么用wagmi 签名调用 erc2612的permit
const App = () => {
  return <>
    <ConnectKitButton />
    <Vault />
  </>
};

export default App
