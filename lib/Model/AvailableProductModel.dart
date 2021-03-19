class AvailableProductModel {
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

  AvailableProductModel.fromJson(Map<String, dynamic> json) {
    this.name = json['Name']??'';
    this.price = json['Price']??0;
    this.image = convert(json['Image'])??[];
    this.detail = json['Detail']??'';
    this.id = json['ID']??'';
    this.quantity = json['Quantity']??0;
    this.discount = json['Discount']??0;
    this.brand = json['Brand']??'';
    this.type = json['Type']??'';
  }

}
