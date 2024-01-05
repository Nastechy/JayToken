
import FungibleToken from 0x05
import FlowToken from 0x05

transaction(mintValue: UFix64) {
 
    let minter: &FlowToken.Minter

    
    let signer: AuthAccount


    prepare(flowSigner: AuthAccount) {
  
      
        self.signer = flowSigner
     
   
        self.minter = self.signer.borrow<&FlowToken.Minter>(from: /storage/FlowMinter)
            ?? panic("No minter resource available ")
    }

   
    execute {

        let newTokens <- self.minter.mintTokens(amount: mintValue)

    
        self.signer.save(<-newTokens, to: /storage/FlowVault)

        
        log("Flow token minted")
    }
}
