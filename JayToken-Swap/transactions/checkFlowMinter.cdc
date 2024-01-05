import FungibleToken from 0x05
import FlowToken from 0x05

transaction() {


  let flowMinter: &FlowToken.Minter

  prepare(account: AuthAccount) {
    
    self.flowMinter = account.borrow<&FlowToken.Minter>(from: /storage/FlowMinter)
        ?? panic("FlowToken Minter is not found")
    log("FlowToken Minter is found")
  }

  execute {
    
  }
}
