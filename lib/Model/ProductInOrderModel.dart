class ProductInOrder{
  bool checked;
  int price;
  String productID;
  int quantity;

  ProductInOrder.fromJson(Map<String, dynamic> json){
   this.checked = json['Checked'];
   this.price = json['Price'];
   this.productID = json['ProductID'];
   this.quantity = json['Quantity'];
  }
}