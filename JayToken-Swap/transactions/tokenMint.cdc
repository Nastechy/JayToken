import FungibleToken from 0x05
import JoyToken from 0x05

transaction(receiver: Address, amount: UFix64) {

    prepare(signer: AuthAccount) {
       
        let minter = signer.borrow<&JoyToken.Minter>(from: /storage/MinterStorage)
            ?? panic("You are not an allowed JoyToken minter")
        
      \
        let receiverVault = getAccount(receiver)
            .getCapability<&JoyToken.Vault{FungibleToken.Receiver}>(/public/Vault)
            .borrow()
            ?? panic("Error: Check your JoyToken Vault status")
        
      
        let mintedTokens <- minter.mintToken(amount: amount)

        
        receiverVault.deposit(from: <-mintedTokens)
    }

    execute {
        log("Minted and deposited successfully")
        log(amount.toString().concat(" Tokens minted and deposited"))
    }
}
