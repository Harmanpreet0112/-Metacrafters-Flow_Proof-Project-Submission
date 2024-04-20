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