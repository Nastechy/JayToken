import FungibleToken from 0x05
import FlowToken from 0x05

transaction (amount: UFix64){
  
    let admin: &FlowToken.Administrator
    
   
    let signer: AuthAccount

  
    prepare(flowSigner: AuthAccount) {
       
        self.signer = flowSigner
       
        self.admin = self.signer.borrow<&FlowToken.Administrator>(from: /storage/newflowTokenAdmin)
            ?? panic("Only admin can call this function")
    }

 
    execute {
       
        let newMinter <- self.admin.createNewMinter(allowedAmount: amount)

 
        self.signer.save(<-newMinter, to: /storage/FlowMinter)

        log("Flow minter created Successfully")
    }
}