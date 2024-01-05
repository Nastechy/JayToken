import FungibleToken from 0x05
import FlowToken from 0x05

transaction() {

    let flowTokenVault: &FlowToken.Vault?
    let account: AuthAccount

    prepare(acct: AuthAccount) {
        
        self.flowTokenVault = acct.getCapability(/public/FlowVault)
            .borrow<&FlowToken.Vault>()

        self.account = acct
    }

    execute {
        if self.flowTokenVault == nil {
        
            let newFlowVault <- FlowToken.createEmptyVault()
            self.account.save(<-newFlowVault, to: /storage/FlowVault)
            self.account.link<&FlowToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, FungibleToken.Provider}>(/public/FlowVault, target: /storage/FlowVault)
            log("Flow Token setup successfully")
        } else {
            log("FlowToken exist already")
        }
    }
}
