// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.7.0 < 0.9.0;

contract Restaurant{

    address public owneraddress;
    address public contrataddress;
    uint public tp; //tottall price
     
     struct foodmenu{
         uint id;
         uint price;
         string name;
     }

     foodmenu[] Foodmenu;

     struct orderlist{
         uint id;
         uint Number;
         uint tprice;
         string name;
         string delivery;
         bool Expiredorder;
         address Customeraddress;
     }
     enum FAZ{
        setmenu,
        setorder,
        setpay
      }

      FAZ public fazes; 

       orderlist[] Orderlist;

     event sent(address from , address to , uint amount);

     constructor (){
         owneraddress = msg.sender;
         contrataddress = address(this);
         fazes = FAZ.setmenu;
     }

     modifier Owner(){
        require(owneraddress == msg.sender,"Only the app owner can log in....");
        _;
     }

     function RegisterMenu(uint id , uint price , string memory name) public Owner(){
         if (Foodmenu.length==0){
             Foodmenu.push(foodmenu(id,price,name));
             fazes = FAZ.setorder;
         } else{        
             uint i;
             for (i=0;i<=Foodmenu.length;i++){
                 require(Foodmenu[i].id == id,"The IDcode entered is duplicate...");
                 Foodmenu.push(foodmenu(id,price,name));
                 fazes = FAZ.setorder;
                }
            }
        }

     function getorder(uint id , uint num ,string memory name , string memory delivery) public payable{
         tp=0;
         uint i;
         for (i=0;i<Foodmenu.length;i++){
             if (Foodmenu[i].id == id){
                 tp=Foodmenu[i].price*num;
                break;
             }
         }
         require(fazes == FAZ.setorder,"You can not order food until the food list is registered");
         require(tp > 0 ,"The desired food was not found");
         //require(msg.value > tp ,"Your account balance is not enough");
         Orderlist.push(orderlist(id,num,tp,name,delivery,false,msg.sender));
         fazes = FAZ.setpay;
     }

     function payment() public payable{
         require(fazes == FAZ.setpay,"There is nothing to pay...");
         uint i;
         tp=0;
         for (i=0;i<Orderlist.length;i++){
              if (msg.sender == Orderlist[i].Customeraddress){
                  if (Orderlist[i].Expiredorder == false){ 
                      Orderlist[i].Expiredorder = true;                     
                      tp += Orderlist[i].tprice;
                  }
              }
         }
         emit sent(msg.sender,contrataddress,tp);   

     }
        

     

}