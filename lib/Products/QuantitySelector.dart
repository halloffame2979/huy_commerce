import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huy_commerce/Model/ProductModel.dart';
import 'package:huy_commerce/Order/OrderingList.dart';

class QuantitySelector extends StatefulWidget {
  final String name;
  final Product product;

  const QuantitySelector({Key key, this.name, this.product}) : super(key: key);

  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  int quantity;

  @override
  void initState() {
    // TODO: implement initState
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
          FlatButton(
            disabledColor: Colors.grey,
            color: Colors.red,
            child: Text(widget.name ?? 'Submit'),
            onPressed: quantity < 1
                ? null
                : () async {
                    var _cloudOrder =
                        FirebaseFirestore.instance.collection('Order');
                    var _userId = FirebaseAuth.instance.currentUser.uid;
                    var _orders = await (_cloudOrder
                        .where('User', isEqualTo: _userId)
                        .where('Status', isEqualTo: 'Ordering')
                        .get());
                    if (_orders.docs.length > 0) {
                      var _userOrder = _orders.docs.first;
                      var docID = _userOrder.id;
                      List<Map> productList =
                          _userOrder.data()['Product'].cast<Map>();
                      int index = productList.indexWhere(
                          (e) => e['ProductID'] == widget.product.id);
                      if (index >= 0) {
                        productList[index]['Quantity'] += quantity;
                        productList[index]['Price'] = widget.product.price;
                        productList[index]['Checked'] = true;
                      } else {
                        productList.add({
                          'Checked': true,
                          'ProductID': widget.product.id,
                          'Quantity': quantity,
                          'Price': widget.product.price,
                        });
                      }
                      _cloudOrder.doc(docID).set({
                        'Product': productList,
                      }, SetOptions(merge: true));
                    } else {
                      _cloudOrder.add({
                        'User': _userId,
                        'Status': 'Ordering',
                        'Product': [
                          {
                            'Checked': true,
                            'ProductID': widget.product.id,
                            'Quantity': quantity,
                            'Price': widget.product.price,
                          },
                        ],
                        // 'Date': Timestamp.fromDate(DateTime.now()),
                      }).then((value) {
                        FirebaseFirestore.instance
                            .collection('User')
                            .doc(_userId)
                            .set({
                          'Order': value.id,
                        }, SetOptions(merge: true));
                      });
                    }
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

class QuantityChanger extends StatefulWidget {
  final Function(int) function;
  final int initQuantity;

  const QuantityChanger({Key key, this.function, this.initQuantity})
      : super(key: key);

  @override
  _QuantityChangerState createState() => _QuantityChangerState();
}

class _QuantityChangerState extends State<QuantityChanger> {
  int quantity;
  var controller = TextEditingController();

  void initState() {
    super.initState();
    quantity = widget.initQuantity ?? 1;
    controller.text = quantity.toString();
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length));
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: IconButton(
                disabledColor: Colors.grey,
                icon: Icon(Icons.remove),
                onPressed: quantity <= 1
                    ? null
                    : () {
                        setState(() {
                          quantity -= 1;
                          controller.text = quantity.toString();
                          controller.selection = TextSelection.fromPosition(
                              TextPosition(offset: controller.text.length));
                        });
                        widget.function(quantity);
                      }),
          ),
          Container(
            height: 20,
            width: 50,
            child: TextField(
              controller: controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 2,
              decoration: InputDecoration(
                counterText: '',
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.deny(RegExp(r'^0+'))
              ],
              onChanged: (val) {
                print(val);
                if (val.isEmpty) {
                  controller.text = '0';
                  controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: controller.text.length));
                  setState(() {
                    quantity = 0;
                  });
                  widget.function(quantity);
                  return;
                }

                setState(() {
                  quantity = int.parse(val);
                });
                widget.function(quantity);
              },
            ),
          ),
          Container(
            child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    quantity += 1;
                    controller.text = quantity.toString();
                    controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: controller.text.length));
                  });
                  widget.function(quantity);
                }),
          ),
        ],
      ),
    );
  }
}
