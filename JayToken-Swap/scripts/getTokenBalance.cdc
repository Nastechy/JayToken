
import FungibleToken from 0x05

pub fun main(user: Address): {UInt64: UFix64} {


    let authAccount = getAuthAccount(user)

    var tokenVault: {UInt64: UFix64} = {}


    authAccount.forEachStored(fun(path: StoragePath, type: Type): Bool {

     
        if type.isSubtype(of: Type<@FungibleToken.Vault>()) {

            let tokenVaultRef = authAccount.borrow<&FungibleToken.Vault>(from: path)!

            tokenVault[tokenVaultRef.uuid] = tokenVaultRef.balance
        }

        return true
    })

    return tokenVault
}
