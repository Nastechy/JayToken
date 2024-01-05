import FungibleToken from 0x05
import JoyToken from 0x05

transaction() {

   
    let userVault: &JoyToken.Vault{FungibleToken.Balance, FungibleToken.Provider, FungibleToken.Receiver, JoyToken.CollectionPublic}?
    let account: AuthAccount

    prepare(acct: AuthAccount) {

      
        self.userVault = acct.getCapability(/public/Vault)
            .borrow<&JoyToken.Vault{FungibleToken.Balance, FungibleToken.Provider, FungibleToken.Receiver, JoyToken.CollectionPublic}>()

        self.account = acct
    }

    execute {
        if self.userVault == nil {
          
            let emptyVault <- JoyToken.createEmptyVault()
            self.account.save(<-emptyVault, to: /storage/VaultStorage)
            self.account.link<&JoyToken.Vault{FungibleToken.Balance, FungibleToken.Provider, FungibleToken.Receiver, JoyToken.CollectionPublic}>(/public/Vault, target: /storage/VaultStorage)
            log("JoyToken vault Created")
        } else {
            log("Vault is available already")
        }
    }
}
