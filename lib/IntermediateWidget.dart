import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'Order/OrderingList.dart';

Future submitYesOrNo(BuildContext context, {Function function}) {
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Confirm?'),
      actions: [
        MaterialButton(
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
        MaterialButton(
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
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: CircularProgressIndicator(),
    );
  }
}

class ProductInCart extends StatefulWidget {
  final bool isBlack;

  const ProductInCart({Key key, this.isBlack = false}) : super(key: key);

  @override
  _ProductInCartState createState() => _ProductInCartState();
}

class _ProductInCartState extends State<ProductInCart> {
  Stream<int> quantity;

  Stream<int> fetch() async* {
    var db = FirebaseFirestore.instance;
    String cartID = (await db
            .collection('User')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .get())
        .data()['Order'];
    Stream cart = db
        .collection('Order')
        .doc(cartID)
        .snapshots()
        .map((event) => event.data()['Product']);

    await for (var products in cart) {
      List<int> snap = [];
      if (products.isEmpty || products == null)
        yield 0;
      else {
        int num = products
            .map((event2) => event2['Quantity'])
            .reduce((value, element) => value + element);
        snap.add(num);
        for (var j in snap) yield j;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    quantity = fetch();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Stack(
        children: [
          Center(
            child: Icon(
              Icons.shopping_cart,
              color: widget.isBlack ? Colors.black : Colors.white,
              size: 27,
            ),
          ),
          StreamBuilder(
              stream: quantity,
              builder: (context, AsyncSnapshot<int> snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  print('\n\n\n\n\n\n\n\n\n');
                  return Text('e');
                }
                if (snapshot.hasData) {
                  var res = snapshot.data;
                  if (res == 0) return Container();
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
