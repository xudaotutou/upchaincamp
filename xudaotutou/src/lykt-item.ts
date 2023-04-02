import { Address } from "@graphprotocol/graph-ts"
import { BigInt } from '@graphprotocol/graph-ts'
import {
  Transfer as TransferEvent
} from "../generated/LYKTItem/LYKTItem"
import { Transfer, User,  } from "../generated/schema"
const ADDRESS_ZERO = "0x0000000000000000000000000000000000000000"
const BigInt_ZERO = BigInt.fromI32(0)
export function handleTransfer(event: TransferEvent): void {
  let entity = new Transfer(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.from = event.params.from
  entity.to = event.params.to
  entity.tokenId = event.params.tokenId

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

function updateUserBalance(from: Address, to: Address, amount: BigInt): void {
  if (from.toHex() != ADDRESS_ZERO) {
    let userFrom = User.load(from.toHex())
    if (!userFrom) {
        userFrom = new User(from.toHex())
        userFrom.balance = BigInt.fromI32(0)
    }

    userFrom.balance = userFrom.balance.minus(amount)
    userFrom.save()
  }


  if (to.toHex() != ADDRESS_ZERO) {
    let userTo = User.load(to.toHex())

    if (!userTo) {
      userTo = new User(to.toHex())
      userTo.balance = BigInt.fromI32(0)
    }

    userTo.balance = userTo.balance.plus(amount)
    userTo.save()
  }
}