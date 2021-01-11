import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:huy_commerce/Model/ProductInOrderModel.dart';
import 'package:huy_commerce/Model/ProductModel.dart';
import 'package:huy_commerce/Products/ProductDetail.dart';
import 'package:huy_commerce/Products/QuantitySelector.dart';
import 'package:intl/intl.dart';

class OrderingBox extends StatelessWidget {
  final ProductInOrder productInOrder;
  final Function(int) onChanged;
  final Function remove;

  const OrderingBox({Key key, this.productInOrder, this.onChanged, this.remove})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int quantity;
    return Container(
      margin: EdgeInsets.all(5),
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Container(
        child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('Product')
                .doc(productInOrder.productID)
                .get(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> product) {
              if (product.connectionState == ConnectionState.done)
                return GestureDetector(
                  onTap: () {
                    var map = product.data.data();
                    map['ID'] = product.data.data()['ID'];
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProductDetail(
                          product: Product.fromJson(map),
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: FutureBuilder(
                            future: FirebaseStorage.instance
                                .ref(product.data.data()['Image'][0])
                                .getData(),
                            builder: (context, AsyncSnapshot image) {
                              if (image.hasData) {
                                return Image.memory(
                                  image.data,
                                );
                              } else
                                return Container();
                            }),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(product.data['Name']),
                            Text(
                              NumberFormat.currency(locale: 'vi').format(
                                product.data['Price'],
                              ),
                            ),
                            QuantityChanger(
                              initQuantity: productInOrder.quantity,
                              function: (num) {
                                quantity = num;
                                onChanged(num);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              else
                return Container();
            }),
      ),
    );
  }
}
