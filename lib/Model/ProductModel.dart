import 'package:flutter/material.dart';

class Product{
  String id;
  String image;
  String name;
  int price;
  String detail;
  Product.fromJson(Map<String,dynamic> json){
    this.name = json['Name'];
    this.price = json['Price'];
    this.image = json['Image'];
    this.detail = json['Detail'];
    this.id = json['ID'];
  }

  Product(this.id, this.image, this.name, this.price, this.detail);
}