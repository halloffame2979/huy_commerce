class ProductInOrderModel{
  bool checked;
  int price;
  String name;
  String productID;
  int quantity;
  String image;
  String brand;

  ProductInOrderModel.fromJson(Map<String, dynamic> json){
   this.checked = json['Checked']??false;
   this.price = json['Price']??1000000000;
   this.name = json['Name'];
   this.productID = json['ProductID']??'';
   this.quantity = json['Quantity']??0;
   this.image = json['Image']??'';
   this.brand = json['Brand']??'';
  }
}