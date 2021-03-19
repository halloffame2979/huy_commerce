import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huy_commerce/Order/OrderingList.dart';

import 'QuantityChanger.dart';

class QuantitySelector extends StatefulWidget {
  final String name;
  final String productID;

  const QuantitySelector({Key key, this.name, this.productID})
      : super(key: key);

  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  int quantity;

  @override
  void initState() {
    super.initState();
    quantity = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Text(
            'Quantity',
            style: TextStyle(fontSize: 15),
          ),
          Divider(
            height: 10,
            color: Colors.transparent,
          ),
          QuantityChanger(
            function: (num) {
              quantity = num;
            },
          ),
          MaterialButton(
            disabledColor: Colors.grey,
            color: Colors.red,
            child: Text(widget.name ?? 'Submit'),
            onPressed: quantity < 1
                ? null
                : () async {
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
                    var _userId = FirebaseAuth.instance.currentUser.uid;
                    var userInfo = (await FirebaseFirestore.instance
                        .collection('User')
                        .doc(_userId)
                        .get());
                    var _cloudOrder =
                        FirebaseFirestore.instance.collection('Order');
                    var _cloudUser =
                        FirebaseFirestore.instance.collection('User');

                    //if user info is null or no user

                    if (userInfo == null) return;
                    if (userInfo.data() == null) return;

                    //////////////////////////////////////////

                    //if no order cart yet
                    if (userInfo.data()['Order'] == null ||
                        userInfo.data()['Order'].isEmpty) {
                      await _cloudOrder.add({
                        'User': _userId,
                        'Status': 'Ordering',
                        'Product': [
                          {
                            'ProductID': widget.productID,
                            'Checked': true,
                            'Quantity': quantity,
                          }
                        ],
                        'CreateAt': Timestamp.fromDate(DateTime.now()),
                      }).then((value) async {
                        await _cloudUser
                            .doc(_userId)
                            .set({'Order': value.id}, SetOptions(merge: true));
                      });
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();

                      return;
                    }

                    /////////////////////////////////

                    var _userOrder =
                        await _cloudOrder.doc(userInfo.data()['Order']).get();

                    //if have cart but cart has no data

                    if (_userOrder == null || _userOrder.data() == null) {
                      await _cloudOrder.doc(userInfo.data()['Order']).set({
                        'User': _userId,
                        'Status': 'Ordering',
                        'Product': [
                          {
                            'ProductID': widget.productID,
                            'Checked': true,
                            'Quantity': quantity,
                          }
                        ],
                        'CreateAt': Timestamp.fromDate(DateTime.now()),
                      });
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      return;
                    } else if (_userOrder.data().isEmpty) {
                      await _cloudOrder.doc(userInfo.data()['Order']).set({
                        'User': _userId,
                        'Status': 'Ordering',
                        'Product': [
                          {
                            'ProductID': widget.productID,
                            'Checked': true,
                            'Quantity': quantity,
                          }
                        ],
                        'CreateAt': Timestamp.fromDate(DateTime.now()),
                      });
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      return;
                    }

                    /////////////////////////////////

                    var docID = _userOrder.id;

                    List<Map> productsInCart =
                        _userOrder.data()['Product'].cast<Map>();

                    var index = productsInCart
                        .indexWhere((e) => e['ProductID'] == widget.productID);

                    if (index >= 0) {
                      productsInCart[index]['Quantity'] += quantity;
                      productsInCart[index]['Checked'] = true;
                    } else {
                      productsInCart.add({
                        'Checked': true,
                        'ProductID': widget.productID,
                        'Quantity': quantity,
                      });
                    }

                    await _cloudOrder.doc(docID).set(
                        {'Product': productsInCart}, SetOptions(merge: true));

                    Navigator.of(context).pop();

                    widget.name == 'Add to Cart'
                        ? Navigator.of(context).pop()
                        : Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => OrderingList(),
                            ),
                          );
                  },
          )
        ],
      ),
    );
  }
}
