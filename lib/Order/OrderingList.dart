import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huy_commerce/IntermediateWidget.dart';
import 'package:huy_commerce/Model/OrderModel.dart';
import 'package:huy_commerce/Model/ProductInOrderModel.dart';
import 'package:huy_commerce/Products/ProductBox.dart';
import 'package:intl/intl.dart';

import 'OrderingBox.dart';

List<String> status = ['Ordering', 'Waiting', 'Shipping', 'Cancel', 'Received'];

class OrderingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _userId = FirebaseAuth.instance.currentUser.uid;
    CollectionReference _order = FirebaseFirestore.instance.collection('Order');
    List<Map<String, dynamic>> productList;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Cart'),
        ),
        body: ListView(
          children: [
            FutureBuilder(
              future: _order
                  .where('User', isEqualTo: _userId)
                  .where('Status', isEqualTo: 'Ordering')
                  .get(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return ErrorMessage();
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data.docs.length > 0 &&
                      snapshot.data.docs[0].data()['Product'].length > 0) {
                    Map map = snapshot.data.docs[0].data();
                    map['ID'] = snapshot.data.docs[0].id;
                    var order = Order.fromJson(map);
                    productList = order.products;
                    var listToUpdate = new List.from(productList);
                    return Column(
                      children: List.generate(
                        productList.length,
                        (index) => Dismissible(
                          background: Container(
                            color: Colors.red,
                            padding: EdgeInsets.only(right: 15),
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Delete',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (dir) async {
                            bool confirm = false;
                            await submitYesOrNo(context, function: () {
                              confirm = true;
                              Navigator.of(context).pop();
                            });
                            return confirm;
                          },
                          onDismissed: (dir) {
                            listToUpdate.remove(productList[index]);

                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => Center(
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        child: CircularProgressIndicator(),
                                      ),
                                    ));

                            FirebaseFirestore.instance
                                .collection('Order')
                                .doc(order.id)
                                .set(
                              {
                                'Product': listToUpdate,
                              },
                              SetOptions(merge: true),
                            ).then((value) => Navigator.of(context).pop());
                          },
                          key: ValueKey(index),
                          child: OrderingBox(
                            onChanged: (num) {
                              productList[index]['Quantity'] = num;
                              FirebaseFirestore.instance
                                  .collection('Order')
                                  .doc(order.id)
                                  .update(
                                {
                                  'Product': productList,
                                },
                              );
                            },
                            productInOrder:
                                ProductInOrder.fromJson(order.products[index]),
                          ),
                        ),
                      ),
                    );
                  } else
                    return Container();
                }

                return Loading();
              },
            ),
            Divider(height: 30, color: Colors.transparent),
            StreamBuilder(
              stream: _order
                  .where('User', isEqualTo: _userId)
                  .where('Status', isEqualTo: 'Ordering')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if ((!snapshot.hasError) &&
                    (snapshot.connectionState == ConnectionState.active) &&
                    (snapshot.data.size == 1) &&
                    snapshot.data.docs[0]['Product'].length > 0) {
                  var order = Order.fromJson(snapshot.data.docs[0].data()
                    ..addAll({'ID': snapshot.data.docs[0].id}));
                  var productList = order.products;
                  return Column(
                    children: [
                      Center(
                        child: Text(
                          'Total Price:',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Center(
                        child: Text(
                          NumberFormat.currency(locale: 'vi').format(productList
                              .map((e) => e['Quantity'] * e['Price'])
                              .reduce((value, element) => value + element)),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Divider(height: 30, color: Colors.transparent),
                      FlatButton(
                        minWidth: MediaQuery.of(context).size.width * 7 / 10,
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          _order.doc(order.id).set(
                            {
                              'Status': 'Waiting',
                              'OrderDate': Timestamp.fromDate(
                                DateTime.now(),
                              ),
                            },
                            SetOptions(merge: true),
                          );
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                        child: Text('Buy'),
                      ),
                    ],
                  );
                } else
                  return Column(
                    children: [
                      Container(
                        height: 100,
                        alignment: Alignment.center,
                        child: Text(
                          'There is no items',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomLeft,
                            colors: [Colors.orangeAccent, Colors.yellow],
                          ),
                          boxShadow: boxShadow,
                        ),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                          child: Text('Continue Shopping'),
                        ),
                      ),
                    ],
                  );
              },
            ),
          ],
        ),
      ),
    );
  }
}
