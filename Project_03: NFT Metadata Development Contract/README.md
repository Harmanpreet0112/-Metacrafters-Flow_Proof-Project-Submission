# Project Objective:

The objective of this endeavor is to enrich an established NFT smart contract by integrating a novel feature named borrowAuthNFT. This feature will be tailored to offer public access for retrieving the metadata of NFTs housed within the blockchain. The initiative encompasses tasks such as establishing accounts, minting NFTs, and crafting scripts to showcase the functionality.

# Contract: Cryptopoops

```cadence
import NonFungibleToken from 0x05
pub contract CryptoPoops: NonFungibleToken {
  pub var totalSupply: UInt64

  pub event ContractInitialized()
  pub event Withdraw(id: UInt64, from: Address?)
  pub event Deposit(id: UInt64, to: Address?)

  pub resource NFT: NonFungibleToken.INFT {
    pub let id: UInt64

    pub let name: String
    pub let favouriteFood: String
    pub let luckyNumber: Int

    init(_name: String, _favouriteFood: String, _luckyNumber: Int) {
      self.id = self.uuid

      self.name = _name
      self.favouriteFood = _favouriteFood
      self.luckyNumber = _luckyNumber
    }
  }

  pub resource Collection: NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic {
    pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}
    

    pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT {
        let nft <- self.ownedNFTs.remove(key: withdrawID) 
                ?? panic("NFT Collection Doesn't Available in a our storage")
        emit Withdraw(id: nft.id, from: self.owner?.address)
        return <- nft
    }

    pub fun deposit(token: @NonFungibleToken.NFT) {
        let nft <- token as! @NFT
        emit Deposit(id: nft.id, to: self.owner?.address)
        self.ownedNFTs[nft.id] <-! nft
    }

    pub fun getIDs(): [UInt64] {
        return self.ownedNFTs.keys
    }

    pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
        return (&self.ownedNFTs[id] as &NonFungibleToken.NFT?)!
    }

    pub fun borrowAuthNFT(id: UInt64): &NFT {
      let ref = (&self.ownedNFTs[id] as auth &NonFungibleToken.NFT?)!
      return ref as! &NFT
    }

    init() {
      self.ownedNFTs <- {}      
    }

    destroy() {
      destroy self.ownedNFTs
    }
  }

  pub fun createEmptyCollection(): @NonFungibleToken.Collection {
    return <- create Collection()
  }

  pub resource Minter {

    pub fun createNFT(name: String, favouriteFood: String, luckyNumber: Int): @NFT {
      return <- create NFT(_name: name, _favouriteFood: favouriteFood, _luckyNumber: luckyNumber)
    }

    pub fun createMinter(): @Minter {
      return <- create Minter()
    }

  }

  init() {
    self.totalSupply = 0
    emit ContractInitialized()
    self.account.save(<- create Minter(), to: /storage/Minter)
  }
}
```
A smart contract named NonFungibleToken from address 0x05. The main contract defined in this code is called CryptoPoops, which inherits from NonFungibleToken.

The CryptoPoops contract consists of several key elements:
```
State Variables: It includes a public variable totalSupply of type UInt64.
Events: Three events are defined: ContractInitialized, Withdraw, and Deposit. These events are used to emit information about contract initialization, withdrawal of NFTs, and depositing of NFTs, respectively.
Resource Types: Two resource types are defined within the contract: NFT and Collection. NFT represents a non-fungible token with properties like id, name, favouriteFood, and luckyNumber. Collection represents a collection of NFTs with functions to withdraw, deposit, get IDs, borrow NFTs, and borrow authenticated NFTs.
Functions: Functions are defined to interact with the NFT collection. These include withdraw, deposit, getIDs, borrowNFT, and borrowAuthNFT. Additionally, there are functions to create an empty collection (createEmptyCollection) and to create a new NFT (createNFT) or Minter (createMinter).
Initialization: In the init function, the totalSupply is initialized to 0, and the ContractInitialized event is emitted. A new instance of Minter is created and saved to storage.
```

Overall, this contract facilitates the management and interaction with non-fungible tokens (NFTs) by defining methods for creating, depositing, withdrawing, and borrowing NFTs. Additionally, it provides mechanisms for authentication when borrowing NFTs.

# Transaction: Vault_Creation

```cadence
import CryptoPoops from 0x05

transaction() {

  prepare(signer: AuthAccount) {
 
    if signer.borrow<&CryptoPoops.Collection>(from: /storage/CryptoPoopsCollection) != nil {
      log("Your Collection Already Created")
      return
    }

    signer.save(<- CryptoPoops.createEmptyCollection(), to: /storage/CryptoPoopsCollection)

    signer.link<&CryptoPoops.Collection>(/public/CryptoPoopsCollection, target: /storage/CryptoPoopsCollection)

    log("Collection Created(YEPP!)")
  }
}
```

This transaction script interacts with the CryptoPoops smart contract, imported from address 0x05. Its purpose is to facilitate the creation of a collection of CryptoPoops tokens.

Firstly, it verifies whether the signer already has a collection of CryptoPoops tokens stored in their account. If a collection is found, it logs a message indicating that the collection already exists and exits the transaction.

If the signer does not have a collection yet, the script proceeds to create an empty collection using the createEmptyCollection() function provided by the CryptoPoops contract. It then saves this newly created collection to the signer's account storage. Additionally, it establishes a public link to the collection so that it can be accessed publicly. Finally, it logs a message confirming the successful creation of the collection.

Overall, this transaction script streamlines the process of creating a collection of CryptoPoops tokens, ensuring that each signer can easily manage their own collection within the blockchain.

### Mint_Meta

```cadence

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
```
This transaction script orchestrates the creation and transfer of a new non-fungible token (NFT) from the CryptoPoops collection to a designated recipient account. It follows these steps:
```
Authentication and Preparation:
The transaction begins with the signer's authentication, ensuring that only authorized individuals can initiate it.
Retrieve References:
References to essential components are acquired. This includes borrowing the Minter reference from storage, necessary for NFT creation, and obtaining the recipient's Collection reference, crucial for depositing the newly minted NFT.
NFT Creation and Transfer:
Utilizing the Minter reference, a new NFT is minted with specified attributes such as name, favorite food, and lucky number. Subsequently, the newly minted NFT is transferred to the recipient's Collection through a deposit operation.
Execution:
Upon successful completion of the transaction, a log message confirms the minting of the NFT metadata.
```

In summary, this transaction script streamlines the process of creating and transferring NFTs within the CryptoPoops ecosystem, facilitating the seamless exchange of unique digital assets between users.

# Scripts: Get_ID 

```cadence
import NonFungibleToken from 0x05
import CryptoPoops from 0x05

pub fun main(acctAddress: Address): [UInt64] {
    
    let pubRef = getAccount(acctAddress).getCapability(/public/CryptoPoopsCollection)
                    .borrow<&CryptoPoops.Collection{NonFungibleToken.CollectionPublic}>()
                    ?? panic("Kindly provdie us valid address.")

    return pubRef.getIDs()
}
```

This script is a public function designed to be invoked with the address of an account as its parameter. It aims to retrieve and return the unique identifiers (IDs) of non-fungible tokens (NFTs) stored within the specified account's CryptoPoops collection. Here's an overview of its operation:
```
Main Function:
The main function acts as the entry point for the script, accepting an account address as its input parameter.
Retrieve Collection Reference:
Within the function, it retrieves a reference to the CryptoPoops collection associated with the specified account. This is achieved by utilizing the account's address to fetch the collection's public capability. If the collection supports NFT functionality, its reference is successfully borrowed for further operations. However, if the collection cannot be accessed or does not support NFT functionality, an error is raised.
Get NFT IDs:
Once the collection reference is obtained, the script retrieves the IDs of the NFTs contained within the collection. This step involves invoking the appropriate method provided by the collection reference to fetch the IDs of all the NFTs stored within it.
Return NFT IDs:
Finally, the script returns the array of NFT IDs retrieved from the collection. This array contains the unique identifiers of all the NFTs owned by the specified account, allowing for further processing or display of the NFT information.
```

### Fetch_Metadata

```cadence
import NonFungibleToken from 0x05
import CryptoPoops from 0x05

pub fun main(acctAddress: Address, id: UInt64): &NonFungibleToken.NFT {

    let contract = getAccount(acctAddress).getCapability(/public/CryptoPoopsCollection)
      .borrow<&CryptoPoops.Collection>() ?? panic("Not Able to borrow NFT Metadata from our storage")
    
  let nftMetaData = contract.borrowAuthNFT(id: id)

  return nftMetaData
}
```
This script imports the NonFungibleToken and CryptoPoops smart contracts from address 0x05. Its main function, main, takes two parameters: an account address (acctAddress) and a non-fungible token ID (id). Within the function, it retrieves the CryptoPoops collection associated with the specified account address. If successful, it proceeds to borrow the authenticated metadata of the specified NFT ID from the collection. Finally, it returns a reference to the borrowed NFT metadata. If any errors occur during the process, it panics with an appropriate error message.




