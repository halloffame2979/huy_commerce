import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huy_commerce/IntermediateWidget.dart';
import 'package:huy_commerce/Model/CartModel.dart';
import 'package:huy_commerce/Model/ProductInOrderModel.dart';
import 'package:huy_commerce/Products/ProductBox.dart';

import 'OrderingBox.dart';

// List<String> status = ['Ordering', 'Waiting', 'Shipping', 'Cancel', 'Received'];

class OrderingList extends StatefulWidget {
  @override
  _OrderingListState createState() => _OrderingListState();
}

class _OrderingListState extends State<OrderingList> {
  int total = 0;
  var a = PageController();
  Future<Map<String, dynamic>> fetch;
  DocumentSnapshot _order;

  List _productsInfo;

  @override
  void initState() {
    super.initState();
    fetch = fetchOrderData(FirebaseAuth.instance.currentUser.uid).then((value) {
      setState(() {
        total = value['total'] ?? 0;
        _order = value['order'];
        _productsInfo = value['products'];
      });
      return value;
    });
  }

  Future<Map<String, dynamic>> fetchOrderData(String userId) async {
    String _userOrderId =
        (await FirebaseFirestore.instance.collection('User').doc(userId).get())
            .data()['Order'];

    //if no record of order in user
    if (_userOrderId.isEmpty)
      return {'order': null, 'products': [], 'total': 0};
    //////////////////////////////

    DocumentSnapshot _order = (await FirebaseFirestore.instance
        .collection('Order')
        .doc(_userOrderId)
        .get());

    // order has no data
    if (_order == null || _order.data() == null)
      return {'order': null, 'products': [], 'total': 0};
    ///////////////////

    var cloudProduct = FirebaseFirestore.instance.collection('Product');
    var storage = FirebaseStorage.instance;
    List products = _order.data()['Product'] ?? [];
    List productsInfo = [];
    int totalPrice = 0;
    for (var product in products) {
      var productInfo =
          (await cloudProduct.doc(product['ProductID']).get()).data();
      String url = '';

      url = (await storage.ref(productInfo['Image'][0]).getDownloadURL());

      totalPrice += product['Quantity'] * productInfo['Price'];
      productsInfo.add({
        'Checked': true,
        'ProductID': product['ProductID'],
        'Quantity': product['Quantity'],
        'Price': productInfo['Price'],
        'Name': productInfo['Name'],
        'Image': url,
      });
    }

    Map<String, dynamic> map = {
      'order': _order,
      'products': productsInfo,
      'total': totalPrice,
    };
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Cart'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: total>0?Container(
          height: 90,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                width: 2,
                color: Colors.grey[300],
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'Total :',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      alignment: Alignment.centerRight,
                      child: Text(
                        total.toString() + ' VND',
                        style: TextStyle(
                          color: Colors.pink,
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    Divider(height: 100, color: Colors.transparent),
                    Divider(height: 30, color: Colors.transparent),
                  ],
                ),
              ),
              MaterialButton(
                minWidth: 200,
                color: Theme.of(context).primaryColor,
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Center(
                      child: Container(
                        height: 60,
                        width: 60,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                  _productsInfo.forEach((product) {
                    FirebaseFirestore.instance.collection('InProgress').add({
                      'ProductID': product['ProductID'],
                      'Quantity': product['Quantity'],
                      'User': FirebaseAuth.instance.currentUser.uid,
                      'OrderAt': Timestamp.fromDate(DateTime.now()),
                      'Status': 'Waiting'
                    });
                  });
                  FirebaseFirestore.instance
                      .collection('Order')
                      .doc(_order.id)
                      .set({'Product': []}, SetOptions(merge: true)).then(
                          (value) {
                            Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 3),
                        content: Text('Ordered'),
                        action: SnackBarAction(
                          label: 'Dismiss',
                          onPressed: () {},
                        ),
                      ),
                    );
                  });

                  setState(() {
                    _productsInfo = [];
                    _order = null;
                    total = 0;
                  });
                },
                child: Text('Buy'),
              ),
            ],
          ),
        ):null,
        body: Builder(
          builder: (context) => FutureBuilder(
            future: fetch,
            builder: (context, AsyncSnapshot<Map> snapshot) {
              if (snapshot.hasError) {
                return ErrorMessage();
              }

              if (snapshot.connectionState == ConnectionState.done) {
                if (_productsInfo.isNotEmpty) {
                  Map map = _order.data();
                  map['ID'] = _order.id;
                  var order = CartModel.fromJson(map);
                  var listToUpdate = new List.from(order.products);
                  return ListView(
                    children: List.generate(
                      _productsInfo.length,
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
                          // listToUpdate.removeAt(index);
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => Center(
                              child: Container(
                                height: 60,
                                width: 60,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          );
                          setState(() {
                            total -= _productsInfo[index]['Quantity']*_productsInfo[index]['Price'];
                            _order.data()['Product'].removeAt(index);
                            _productsInfo.removeAt(index);
                          });

                          FirebaseFirestore.instance
                              .collection('Order')
                              .doc(order.id)
                              .set(
                            {
                              'Product': _productsInfo.map((e) {
                                return {
                                  'Checked': e['Checked'],
                                  'ProductID': e['ProductID'],
                                  'Quantity': e['Quantity'],
                                };
                              }).toList(),
                            },
                            SetOptions(merge: true),
                          ).then((value) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text('Deleted Product'),
                                action: SnackBarAction(
                                  label: 'Dismiss',
                                  onPressed: () {},
                                ),
                              ),
                            );
                          })
                          //     .catchError((){
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     SnackBar(
                          //       duration: Duration(seconds: 3),
                          //       content: Text('Fail to delete product'),
                          //       action: SnackBarAction(
                          //         label: 'Dismiss',
                          //         onPressed: () {},
                          //       ),
                          //     ),
                          //   );
                          // })
                          ;

                        },
                        key: UniqueKey(),
                        child: OrderingBox(
                          onChanged: (num) {
                            listToUpdate[index]['Quantity'] = num;
                            setState(() {
                              _productsInfo[index]['Quantity'] = num;
                              _order.data()['Product'][index]['Quantity'] = num;
                              total = _productsInfo
                                  .map((pro) => pro['Quantity'] * pro['Price'])
                                  .reduce((value, element) => value + element);
                            });
                            FirebaseFirestore.instance
                                .collection('Order')
                                .doc(order.id)
                                .update(
                              {
                                'Product': _productsInfo.map((e) {
                                  return {
                                    'Checked': e['Checked'],
                                    'ProductID': e['ProductID'],
                                    'Quantity': e['Quantity'],
                                  };
                                }).toList(),
                              },
                            );
                          },
                          product: ProductInOrderModel.fromJson(
                              _productsInfo[index]),
                        ),
                      ),
                    )..addAll([
                        Divider(
                          height: 100,
                          color: Colors.transparent,
                        ),
                      ]),
                  );
                } else
                  return Center(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomLeft,
                          colors: [Colors.orangeAccent, Colors.yellow],
                        ),
                        boxShadow: boxShadow,
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                        child: Text('Continue Shopping'),
                      ),
                    ),
                  );
              }

              return Loading();
            },
          ),
        ),
      ),
    );
  }
}
