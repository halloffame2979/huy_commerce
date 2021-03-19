import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  String id;
  String user;
  String status;
  List<Map<String, dynamic>> products;
  Timestamp orderDate;
  Timestamp actionDate;
  int totalPrice = 0;

  CartModel.fromJson(Map<String, dynamic> json) {
    this.id = json['ID'] ?? '';
    this.status = json['Status'] ?? '';
    this.products = json['Product'].cast<Map<String, dynamic>>() ?? [];
    this.orderDate = json['CreateAt'] ?? Timestamp.fromDate(DateTime.now());
    this.actionDate = json['ActionAt'] ?? Timestamp.fromDate(DateTime.now());
    // this.totalPrice = this.products.length > 0
    //     ? this
    //         .products
    //         .map((e) => e['Quantity'] * e['Price']).toList()
    //         .reduce((value, element) => value + element)
    //     : 0;
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
