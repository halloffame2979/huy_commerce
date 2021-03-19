import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huy_commerce/IntermediateWidget.dart';
import 'package:huy_commerce/Model/ProductInOrderModel.dart';
import 'package:huy_commerce/Order/FinishedOrder.dart';
import 'package:huy_commerce/Order/NoOrder.dart';

// 'Ordering'

class OrderHistory extends StatefulWidget {
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  int selected;
  Future<List> fetch;

  @override
  void initState() {
    super.initState();
    selected = 0;
    fetch = _fetchData(FirebaseAuth.instance.currentUser.uid);
  }

  Future<List> _fetchData(String userId) async {
    var fireStore = FirebaseFirestore.instance;
    List<Map> inProgressProducts = (await fireStore
            .collection('InProgress')
            .where('User', isEqualTo: userId)
            .orderBy('OrderAt', descending: true)
            .get())
        .docs
        .map((product) {
      var map = product.data();
      map['ID'] = product.id;
      return map;
    }).toList();

    if (inProgressProducts.isEmpty) return [];
    var products = [];
    for (var i in inProgressProducts) {
      var productInfo =
          (await fireStore.collection('Product').doc(i['ProductID']).get());
      var url = (await FirebaseStorage.instance
          .ref(productInfo['Image'][0])
          .getDownloadURL());
      var name = productInfo['Name'];
      var price = productInfo['Price'];
      var brand = productInfo['Brand'];
      var map = {'Image': url, 'Name': name, 'Price': price, 'Brand': brand}
        ..addAll(i);
      products.add(map);
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    List<String> status = ['All', 'Waiting', 'Shipping', 'Cancel', 'Received'];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('History'),
        ),
        body: Column(
          children: [
            Container(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(
                  5,
                  (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(12),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: selected == index
                          ? BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    width: 3,
                                    color: Theme.of(context).primaryColor),
                              ),
                            )
                          : null,
                      child: Text(
                        status[index],
                        style: TextStyle(
                          fontSize: selected == index ? 18 : 16,
                          fontWeight:
                              selected == index ? FontWeight.bold : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Divider(
              height: 5,
              thickness: 3,
            ),
            Expanded(
              child: FutureBuilder(
                future: fetch,
                builder: (context, AsyncSnapshot<List> snap) {
                  if (snap.hasError) return ErrorMessage();
                  if (snap.connectionState == ConnectionState.done) {
                    if (snap.data.isEmpty) {
                      return NoOrder();
                    }
                    var products = snap.data.where((element) {
                      return status[selected] == 'All'
                          ? true
                          : element['Status'] == status[selected];
                    }).toList();
                    if (products.isEmpty) return NoOrder();
                    return ListView(
                      children: List.generate(products.length, (index) {
                        var product = products[index];
                        return FinishedOrder(
                          product: ProductInOrderModel.fromJson(product),
                          status: product['Status'],
                        );
                      }),
                    );
                  }
                  return Loading();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
