import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:huy_commerce/Model/ProductModel.dart';

import 'ProductBox.dart';

class ProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Product').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> product) {
        if (product.hasError)
          return Center(
            child: Text('Error'),
          );
        if (product.connectionState == ConnectionState.active) {
          return GridView.count(
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            crossAxisCount: 2,
            childAspectRatio: 3 / 5,
            padding: EdgeInsets.all(6),
            children: product.data.docs.map(
              (e) {
                Map map = e.data();
                map['ID'] = e.id;
                return ProductBox(
                  product: Product.fromJson(map),
                );
              },
            ).toList(),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
