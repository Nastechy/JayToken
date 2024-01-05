import JoyToken from 0x05
import FungibleToken from 0x05
import FlowToken from 0x05

transaction(acct: Address, value: UFix64) {

    // Define references
    let senderVault: &JoyToken.Vault{JoyToken.CollectionPublic}
    let signerVault: &JoyToken.Vault
    let senderFlowVault: &FlowToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, FungibleToken.Provider}
    let adminResource: &JoyToken.Admin
    let flowMinter: &FlowToken.Minter

    prepare(acct: AuthAccount) {
        
        self.adminResource = acct.borrow<&JoyToken.Admin>(from: /storage/AdminStorage)
            ?? panic("Admin Resource is not present")

        self.signerVault = acct.borrow<&JoyToken.Vault>(from: /storage/VaultStorage)
            ?? panic("Vault missing in acct")

        self.senderVault = getAccount(acct)
            .getCapability(/public/Vault)
            .borrow<&JoyToken.Vault{JoyToken.CollectionPublic}>()
            ?? panic("Vault missing in acct")

        self.senderFlowVault = getAccount(acct)
            .getCapability(/public/FlowVault)
            .borrow<&FlowToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, FungibleToken.Provider }>()
            ?? panic("Flow vault missing in acct")

        self.flowMinter = acct.borrow<&FlowToken.Minter>(from: /storage/FlowMinter)
            ?? panic("Minter is not present")
    }

    execute {
     
        let newVault <- self.adminResource.adminGetCoin(senderVault: self.senderVault, amount: value)        
        log(newVault.balance)
        
  
        self.signerVault.deposit(from: <-newVault)

     
        let newFlowVault <- self.flowMinter.mintTokens(amount: value)

       
        self.senderFlowVault.deposit(from: <-newFlowVault)
        log("Swap Completed Successfully !!!")
    }
}
