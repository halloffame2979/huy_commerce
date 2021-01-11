import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String id;
  String user;
  String status;
  List<Map<String, dynamic>> products;
  Timestamp orderDate;
  Timestamp actionDate;
  int totalPrice;

  Order.fromJson(Map<String, dynamic> json) {
    this.id = json['ID'];
    this.user = json['User'];
    this.status = json['Status'];
    this.products = json['Product'].cast<Map<String, dynamic>>();
    this.orderDate = json['OrderDate'];
    this.actionDate = json['ActionDate'];
    this.totalPrice = this.products
        .map((e) => e['Quantity'] * e['Price'])
        .reduce((value, element) => value + element);
  }

  Map toJson() {
    return {
      'User': user,
      'Status': 'Waiting',
      'Product': products,
      'OrderDate': Timestamp.fromDate(DateTime.now()),
      'TotalPrice': totalPrice,
    };
  }
}
