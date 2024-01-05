import FungibleToken from 0x05
import JoyToken from 0x05

transaction(receiverAddress: Address, value: UFix64) {

    let signerVault: &JoyToken.Vault
    let receiverVault: &JoyToken.Vault{FungibleToken.Receiver}

    prepare(acct: AuthAccount) {
        // Borrow references and handle errors
        self.signerVault = acct.borrow<&JoyToken.Vault>(from: /storage/VaultStorage)
            ?? panic("No vault found for this sender")

        self.receiverVault = getAccount(receiverAddress)
            .getCapability(/public/Vault)
            .borrow<&JoyToken.Vault{FungibleToken.Receiver}>()
            ?? panic("No Vault found for this receiverAddress")
    }

    execute {
      
        self.receiverVault.deposit(from: <-self.signerVault.withdraw(amount: value))
        log("Token transferred to receiver vault")
    }
}
