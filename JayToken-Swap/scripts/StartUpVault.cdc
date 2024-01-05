
import FungibleToken from 0x05
import JoyToken from 0x05

pub fun main(account: Address) {

    let publicVault = getAccount(account)
        .getCapability(/public/Vault)
        .borrow<&JoyToken.Vault{FungibleToken.Balance}>()
        ?? panic("Vault did not setup, try again")

  
    log("Vault setup correctly")
}
