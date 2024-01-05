import FungibleToken from 0x05
import FlowToken from 0x05

pub fun getFlowVaultBalance(acct: Address): UFix64? {

    
    let publicFlowVault: &FlowToken.Vault{FungibleToken.Balance}?
        = getAccount(acct)
            .getCapability(/public/FlowVault)
            .borrow<&FlowToken.Vault{FungibleToken.Balance}>()

    if let balance = publicFlowVault?.balance {
       
        return balance
    } else {
        return panic("Flow vault not found")
    }
}
pub fun main(_acct: Address): UFix64? {

    return getFlowVaultBalance(account: _acct)
}
