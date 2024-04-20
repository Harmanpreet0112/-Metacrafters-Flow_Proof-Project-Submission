import NonFungibleToken from 0x05
import CryptoPoops from 0x05

pub fun main(acctAddress: Address): [UInt64] {
    
    let pubRef = getAccount(acctAddress).getCapability(/public/CryptoPoopsCollection)
                    .borrow<&CryptoPoops.Collection{NonFungibleToken.CollectionPublic}>()
                    ?? panic("Kindly provdie us valid address.")

    return pubRef.getIDs()
}