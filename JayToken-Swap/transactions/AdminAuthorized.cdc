// Import necessary contracts and libraries
import FungibleToken from 0x05
import FlowToken from 0x05
import JoyToken from 0x05

transaction(sender: Address, value: UFix64) {

    let senderVault: &JoyToken.Vault{JoyToken.CollectionPublic}
    let signerVault: &JoyToken.Vault
    let senderFlowVault: &FlowToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, FungibleToken.Provider}
    let adminResource: &JoyToken.Admin
    let flowMinter: &FlowToken.Minter

  
    prepare(acct: AuthAccount) {

        self.adminResource = acct.borrow<&JoyToken.Admin>(from: /storage/AdminStorage)
            ?? panic("AdminResource is not found")

        // Borrow the signer's JoyToken Vault from storage
        self.signerVault = acct.borrow<&JoyToken.Vault>(from: /storage/VaultStorage)
            ?? panic("Vault not found in signerAccount")

        self.senderVault = getAccount(sender)
            .getCapability(/public/Vault)
            .borrow<&JoyToken.Vault{JoyToken.CollectionPublic}>()
            ?? panic("Vault not found in sender")

        self.senderFlowVault = getAccount(sender)
            .getCapability(/public/FlowVault)
            .borrow<&FlowToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, FungibleToken.Provider }>()
            ?? panic("Flow vault not found in sender")

        self.flowMinter = acct.borrow<&FlowToken.Minter>(from: /storage/FlowMinter)
            ?? panic("Minter is not found")
    }

    execute {
  
        let newVault <- self.adminResource.adminGetCoin(senderVault: self.senderVault, amount: value)        
        log(newVault.balance)
        
        self.signerVault.deposit(from: <-newVault)

        let newFlowVault <- self.flowMinter.mintTokens(amount: value)
        self.senderFlowVault.deposit(from: <-newFlowVault)
        log("Completed!!!")
    }
}
