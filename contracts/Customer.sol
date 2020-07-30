pragma solidity ^0.5.0;


contract Customer {


  struct Customer {
    uint cid;
    string cName;
    uint purchaseOrderCount;
    uint receiveOrderCount;
    
  }
  
    struct Supplier{
      uint sid;
      string sName;
     
  }

struct Item {
    uint idItem;
    string itemName;
    bool isDeleted;
    uint price;
    address supplier;
  }
  
  address owner;

  struct Order {
    uint Oid;
    uint cid;
    string itemName;
    uint quantity;
    bool status;
  }

uint public Items ;
 
  mapping (address => Customer) public customers;
  //mapping(address => Item[])supplierItems;
  mapping (address => Order[]) public orders;
  mapping(address => Supplier)public suppliers;
  mapping(uint => Item) public items;
  mapping(address=>bool) public isCustomer;
  mapping(address => bool) public isSupplier;

event ItemAdd(uint idItem);
event ItemRemove(uint idItem);
event OrderRaisedOrUpdated(uint idOrder);

  constructor() public {
  owner=msg.sender;
  }

modifier validCustomer  {
    require(isCustomer[msg.sender],"Not a valid customer");
    _;
}

modifier validSupplier  {
    require(isSupplier[msg.sender],"not a valid supplier");
    _;
}
function registerCustomer(uint cid, string memory cName) public{
    customers[msg.sender]=Customer(cid,cName,0,0);
    isCustomer[msg.sender]=true;
}
function registerSupplier(uint cid, string memory cName) public{
    suppliers[msg.sender]=Supplier(cid,cName);
    isSupplier[msg.sender]=true;
}

  function addItem(string memory itemName, uint price) validSupplier public {
    uint idItem = ++Items;
    items[idItem] = Item(idItem, itemName,false, price,msg.sender);
    emit ItemAdd(idItem);
  }

function removeItem(uint itemId) validSupplier public {
    Item storage item = items[itemId];
    require(item.supplier==msg.sender,"not authorized to remove item");
    item.isDeleted=true;
    emit ItemRemove(itemId);
}
  
  function purchaseItem(uint itemId, string memory itemName,uint  customerId,uint quantity) validCustomer public {
      
    Order[] storage tempOrders = orders[msg.sender];
     customers[msg.sender].purchaseOrderCount++;
    tempOrders.push(Order(customers[msg.sender].purchaseOrderCount, customerId, itemName, quantity,false));
    orders[msg.sender]=tempOrders;
    
   
    emit OrderRaisedOrUpdated(customers[msg.sender].purchaseOrderCount);
  }

  function recieveItem(uint oid) validCustomer public {
     
      
      orders[msg.sender][oid].status=true;
      customers[msg.sender].receiveOrderCount++;
      emit OrderRaisedOrUpdated(oid);
  }

 
  function getOrderDetails(uint oid) validCustomer view public returns (string memory, uint, bool){
   return (orders[msg.sender][oid].itemName, orders[msg.sender][oid].quantity, orders[msg.sender][oid].status);
  }

  function getNumberOfItemsPurchased() validCustomer view public returns (uint) {
    return customers[msg.sender].purchaseOrderCount;
  }

  function getNumberOfItemsReceived() validCustomer view public returns (uint) {
    return customers[msg.sender].receiveOrderCount;
  }
  

 

  

}
