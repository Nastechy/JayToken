
import FungibleToken from 0x05
import JoyToken from 0x05

pub fun main(acct: Address) {

    let publicVault: &JoyToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, JoyToken.CollectionPublic}? =
        getAccount(account).getCapability(/public/Vault)
            .borrow<&JoyToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, JoyToken.CollectionPublic}>()

    if (publicVault == nil) {
        let newVault <- JoyToken.createEmptyVault()
        getAuthAccount(act).save(<-newVault, to: /storage/VaultStorage)
        getAuthAccount(act).link<&JoyToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, JoyToken.CollectionPublic}>(
            /public/Vault,
            target: /storage/VaultStorage
        )        
        // Retrieve the newly created vault's balance and log it
        let retrievedVault: &JoyToken.Vault{FungibleToken.Balance}? =
            getAccount(act).getCapability(/public/Vault)
                .borrow<&JoyToken.Vault{FungibleToken.Balance}>()
        log("Vault Balance: \(retrievedVault?.balance ?? 0.0)")
    } else {        
        let checkVault: &JoyToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, JoyToken.CollectionPublic} =
            getAccount(act).getCapability(/public/Vault)
                .borrow<&JoyToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, JoyToken.CollectionPublic}>()
                ?? panic("JoyToken vault capability is unavailable")

        if JoyToken.vaults.contains(checkVault.uuid) {
           
            log("Vault Balance: \(publicVault?.balance ?? 0.0)")
        log("JoyToken vault")
        } else {
           
            log("This is not JoyToken Vault try again")
        }
    }
}
