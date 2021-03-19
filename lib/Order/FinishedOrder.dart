import 'package:flutter/material.dart';
import 'package:huy_commerce/Model/ProductInOrderModel.dart';
import 'package:huy_commerce/Products/ProductDetail.dart';
import 'package:intl/intl.dart';

class FinishedOrder extends StatelessWidget {
  final ProductInOrderModel product;
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
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductDetail(
                    productID: product.productID,
                  ),
                ),
              );
            },
            child: Container(
              child: Column(
                children: [
                  startAndEndText(
                    product.brand,
                    status,
                    isBold: true,
                    color: Theme.of(context).primaryColor,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Image.network(product.image),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
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
                                      NumberFormat.currency(locale: 'vi')
                                          .format(
                                        product.price,
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
                          product.price * product.quantity,
                        ),
                  ),
                  Divider(
                    thickness: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
