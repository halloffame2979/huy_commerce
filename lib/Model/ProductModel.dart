class Product {
  String id;
  List<String> image;
  String name;
  int price;
  String detail;
  int quantity;
  int discount;
  String brand;
  String type;

  List<String> convert(List<dynamic> list) {
    return list.cast<String>();
  }

  Product.fromJson(Map<String, dynamic> json) {
    this.name = json['Name'];
    this.price = json['Price'];
    this.image = convert(json['Image']);
    this.detail = json['Detail'];
    this.id = json['ID'];
    this.quantity = json['Quantity'];
    this.discount = json['Discount'];
    this.brand = json['Brand'];
    this.type = json['Type'];
  }

  Product(this.id, this.image, this.name, this.price, this.detail);
}
