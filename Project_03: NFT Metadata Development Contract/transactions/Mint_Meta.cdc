
import NonFungibleToken from 0x05
import CryptoPoops from 0x05

transaction(recipientAccount: Address, _name: String, _favFood: String, _luckyNo: Int) {
  prepare(signer: AuthAccount) {

    let minter = signer.borrow<&CryptoPoops.Minter>(from: /storage/Minter)!

    let pubrecipientRef = getAccount(recipientAccount).getCapability(/public/CryptoPoopsCollection)
                    .borrow<&CryptoPoops.Collection{NonFungibleToken.CollectionPublic}>()
                    ?? panic("We Couldn't find your collection")

    let nft <- minter.createNFT(name: _name, favouriteFood: _favFood, luckyNumber: _luckyNo)
    
    pubrecipientRef.deposit(token: <- nft)
  }

  execute {
    log("NFT Metadata minted successfully")
  }
}
