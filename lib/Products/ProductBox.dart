import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:huy_commerce/Model/ProductModel.dart';
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
  final Product product;

  const ProductBox({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var storage = FirebaseStorage.instance;

    var img = storage.ref(product.image[0]);
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ProductDetail(product: product),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: boxShadow,
        ),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: img.getDownloadURL(),
                builder: (context, AsyncSnapshot<String> imageUrl) {
                  return imageUrl.connectionState == ConnectionState.done
                      ? Image.network(imageUrl.data)
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                },
              ),
              flex: 5,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 7),
                child: Text(
                  product.name,
                  textAlign: TextAlign.left,
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
                  'Giá: ' +
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
