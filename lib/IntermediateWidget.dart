import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Order/OrderingList.dart';

Future submitYesOrNo(BuildContext context, {Function function}) {
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Confirm?'),
      actions: [
        FlatButton(
          color: Theme.of(context).primaryColor,
          child: Container(
            child: Text(
              'Yes',
              style: TextStyle(color: Colors.black),
            ),
            height: 20,
          ),
          onPressed: function,
        ),
        FlatButton(
          color: Colors.grey[200],
          child: Container(
            child: Text(
              'No',
              style: TextStyle(color: Colors.black),
            ),
            height: 20,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
    barrierDismissible: true,
  );
}

class ErrorMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'ERROR',
        style: TextStyle(
          color: Colors.red,
          fontSize: 50,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class ProductInCart extends StatelessWidget {
  final bool isBlack;

  const ProductInCart({Key key, this.isBlack = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Stack(
        children: [
          Center(
            child: Icon(
              Icons.shopping_cart,
              color: isBlack ? Colors.black : Colors.white,
              size: 27,
            ),
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Order')
                  .where('User',
                      isEqualTo: FirebaseAuth.instance.currentUser.uid)
                  .where('Status', isEqualTo: 'Ordering')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.docs.isEmpty) return Container();
                  var products = snapshot.data.docs[0]['Product'];
                  if (products.length > 0) {
                    var res = products
                        .map((e) {
                          return e['Quantity'];
                        })
                        .toList()
                        .reduce((value, element) => value + element);
                    return Positioned(
                      right: 0,
                      child: new Container(
                        padding: EdgeInsets.all(1),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: new Text(
                          '$res',
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                }
                return Container();
              }),
        ],
      ),
      onPressed: () {
        (Navigator.of(context)..popUntil((route) => route.isFirst))
            .push(MaterialPageRoute(builder: (context) => OrderingList()));
      },
    );
  }
}
