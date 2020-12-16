import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huy_commerce/Model/ProductModel.dart';

class QuantitySelector extends StatefulWidget {
  final String name;
  final Product product;

  const QuantitySelector({Key key, this.name, this.product}) : super(key: key);

  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  int quantity;
  var controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    quantity = 1;
    controller.text = quantity.toString();
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length));
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
          Row(
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
                    if (val.isEmpty) {
                      controller.text = '0';
                      controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: controller.text.length));
                      setState(() {
                        quantity = 0;
                      });
                      return;
                    }

                    setState(() {
                      quantity = int.parse(val);
                    });
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
                    }),
              ),
            ],
          ),
          FlatButton(
            disabledColor: Colors.grey,
            color: Colors.red,
            child: Text(widget.name ?? 'Submit'),
            onPressed: quantity < 1
                ? null
                : () async {
                    var _cloud = FirebaseFirestore.instance.collection('Order');
                    var _user = FirebaseAuth.instance.currentUser.uid;
                    var _orders = await (_cloud
                        .where('User', isEqualTo: _user)
                        .where('Status', isEqualTo: 'Ordering')
                        .get());
                    var _userOrder = _orders.docs.first;
                    var docID = _userOrder.id;
                    List<Map> a = _userOrder.data()['Product'].cast<Map>();
                    int index = a
                        .indexWhere((e) => e['ProductID'] == widget.product.id);
                    if (index >= 0) {
                      a[index]['Quantity'] += quantity;
                      a[index]['Checked'] = true;
                    } else {
                      a.add({
                        'Checked': true,
                        'ProductID': widget.product.id,
                        'Quantity': quantity
                      });
                    }
                    _cloud
                        .doc(docID)
                        .set({'Product': a}, SetOptions(merge: true));
                  },
          )
        ],
      ),
    );
  }
}
