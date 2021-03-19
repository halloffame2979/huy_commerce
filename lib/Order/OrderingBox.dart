import 'package:flutter/material.dart';
import 'package:huy_commerce/Model/ProductInOrderModel.dart';
import 'package:huy_commerce/Products/ProductDetail.dart';
import 'package:huy_commerce/Products/QuantityChanger.dart';
import 'package:intl/intl.dart';

class OrderingBox extends StatelessWidget {
  final ProductInOrderModel product;

  // final Order
  final Function(int) onChanged;
  final Function remove;

  const OrderingBox({Key key, this.product, this.onChanged, this.remove})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        padding: EdgeInsets.only(left: 20),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]),
                ),
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
                  child: product.image != null
                      ? Image.network(product.image)
                      : Container(),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(product.name),
                  Text(
                    NumberFormat.currency(locale: 'vi').format(
                      product.price,
                    ),
                  ),
                  QuantityChanger(
                    initQuantity: product.quantity,
                    function: (num) {
                      onChanged(num);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
