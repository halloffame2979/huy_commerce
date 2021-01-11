import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:huy_commerce/IntermediateWidget.dart';
import 'package:huy_commerce/Model/ProductInOrderModel.dart';
import 'package:huy_commerce/Model/ProductModel.dart';
import 'package:huy_commerce/Products/ProductDetail.dart';
import 'package:intl/intl.dart';

class FinishedOrder extends StatelessWidget {
  final ProductInOrder product;
  final String status;

  const FinishedOrder({Key key, this.product, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget startAndEndText(String text1, String text2,
        {bool isBold = false, Color color}) {
      return Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.centerLeft,
            height: 22,
            child: Text(
              text1,
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: isBold ? FontWeight.bold : null,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.centerLeft,
            height: 22,
            child: Text(
              text2,
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: isBold ? FontWeight.bold : null,
              ),
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      );
    }

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          // height: 300,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Product')
                  .doc(product.productID)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.active)
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProductDetail(
                            product: Product.fromJson(snapshot.data.data()),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      child: Column(
                        children: [
                          startAndEndText(
                            snapshot.data['Brand'],
                            status,
                            isBold: true,
                            color: Theme.of(context).primaryColor,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: FutureBuilder(
                                    future: FirebaseStorage.instance
                                        .ref(snapshot.data.data()['Image'][0])
                                        .getData(),
                                    builder:
                                        (context, AsyncSnapshot image) {
                                      if (image.hasData) {
                                        return Image.memory(
                                              image.data,
                                            )
                                            ;
                                      } else
                                        return Container();
                                    }),
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data['Name'],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 17,
                                        ),
                                      ),
                                      Divider(color: Colors.transparent),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Price each: ' +
                                              NumberFormat.currency(
                                                      locale: 'vi')
                                                  .format(
                                                snapshot.data['Price'],
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          startAndEndText(
                            '${product.quantity} product/s',
                            'Total Price: ' +
                                NumberFormat.currency(locale: 'vi').format(
                                  snapshot.data['Price'] * product.quantity,
                                ),
                          ),
                          Divider(thickness: 1,),
                        ],
                      ),
                    ),
                  );
                else
                  return Container();
              }),
        ),
      ],
    );
  }
}
