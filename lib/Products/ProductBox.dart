import 'package:flutter/material.dart';
import 'package:huy_commerce/Model/AvailableProductModel.dart';
import 'package:intl/intl.dart';

import 'ProductDetail.dart';

var boxShadow = [
  BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.23),
      offset: Offset(0, 6),
      blurRadius: 6),
  BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.19),
      offset: Offset(0, 10),
      blurRadius: 20)
];

class ProductBox extends StatelessWidget {
  final AvailableProductModel product;

  const ProductBox({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ProductDetail(productID: product.id),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: boxShadow,
        ),
        child: Column(
          children: [
            Expanded(
              child: Image.network(product.image[0]),
              flex: 5,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 7),
                alignment: Alignment.centerLeft,
                child: Text(
                  product.name,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
              flex: 1,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  'Price: ' +
                      NumberFormat.currency(locale: 'vi').format(product.price),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
