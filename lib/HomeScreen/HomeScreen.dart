import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huy_commerce/IntermediateWidget.dart';
import 'package:huy_commerce/Products/ProductList.dart';

import 'DrawerMenu.dart';

class HomeScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('HSCom'),
          actions: [
            ProductInCart(),
          ],
        ),
        drawer: DrawerMenu(),
        body: ProductList(),
      ),
    );
  }
}




