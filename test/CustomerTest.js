const Customer = artifacts.require('./Customer.sol')
require('chai')
  .use(require('chai-as-promised'))
  .should()

  contract('Customer', (accounts) => {
    let customer
    
  
    before(async () => {
      customer = await Customer.deployed()
      
    })
    describe('contracts deployment', async () => {
        it('deploys Customer contract successfully', async () => {
  
          const customerAddress = await customer.address
          assert.notEqual(customerAddress, 0x0)
          assert.notEqual(customerAddress, '')
          assert.notEqual(customerAddress, null)
          assert.notEqual(customerAddress, undefined)
               
        })
    })

    describe('register users', async () => {
        it('register Customer', async () =>{
             await customer.registerCustomer("1","customer1",{from : accounts[1]})
             let isCustomer = await customer.isCustomer(accounts[1])
             assert.equal(isCustomer,true)
            
        })
  
        it('register Supplier', async () =>{
           await customer.registerSupplier("1","supplier1",{from : accounts[2]})
           let isSupplier = await customer.isSupplier(accounts[2])
          
           assert.equal(isSupplier,true)
         
          
           
      })
      })

      describe('supplier items', async () =>{
        it('add item', async () =>{
            await customer.addItem("item1","100",{from : accounts[2]})
            
            let itemCount = await customer.Items()
            console.log("Items: ",itemCount)
            assert.equal(itemCount,1)
           
       })
      })
      describe('Customer orders', async () =>{
        it('purchase item', async () =>{
            await customer.purchaseItem("1","item1","1","10",{from : accounts[1]})
           
            let purchaseOrderCount = await customer.getNumberOfItemsPurchased({from : accounts[1]})
            assert.equal(purchaseOrderCount,1)
           
       })

     

       it('receive item', async () =>{
        await customer.recieveItem("0",{from : accounts[1]})
        
        let receiveOrderCount = await customer.getNumberOfItemsReceived({from : accounts[1]})
        assert.equal(receiveOrderCount,1)
   })
      })

      describe('negative test case', async () =>{
        it('customer adds item', async () =>{
            await customer.addItem("item1","100",{from : accounts[1]})
            
            let itemCount = await customer.Items()
            console.log("Items: ",itemCount)
            assert.equal(itemCount,2)
           
       })
      })


})