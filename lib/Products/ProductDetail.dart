import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huy_commerce/IntermediateWidget.dart';
import 'package:huy_commerce/Model/ProductModel.dart';
import 'package:huy_commerce/Order/OrderingList.dart';
import 'package:intl/intl.dart';

import 'ImageSlide.dart';
import 'QuantitySelector.dart';

class ProductDetail extends StatelessWidget {
  final Product product;

  const ProductDetail({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomLeft,
                    colors: [Colors.orangeAccent, Colors.yellow],
                  ),
                ),
                child: FlatButton(
                  disabledColor: Colors.grey,
                  height: 60,
                  onPressed: product.quantity > 0
                      ? () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => QuantitySelector(
                              name: 'Add to Cart',
                              product: product,
                            ),
                            //builder: (context) => QuantityChanger()
                          );
                        }
                      : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_shopping_cart),
                      Text('Add to Cart'),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: 1,
              height: 0,
            ),
            Expanded(
              child: Container(
                color: Colors.orange,
                child: FlatButton(
                  disabledColor: Colors.grey,
                  height: 60,
                  onPressed: product.quantity > 0
                      ? () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => QuantitySelector(
                                    name: 'Buy Now',
                                    product: product,
                                  ));
                        }
                      : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag),
                      Text('Buy Now'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              elevation: 5,
              backgroundColor: Colors.white,
              expandedHeight: 50,
              floating: true,
              title: Text(
                product.name,
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                ProductInCart(isBlack: true,),
              ],
              iconTheme: IconThemeData(
                color: Theme.of(context).primaryColor,
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate(
              [
                ImageSlide(
                  imageList: product.image,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                  child: Text(
                    product.name,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      // alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 7),
                      child: Text(
                        'Brand: ' + product.brand,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 2,
                      thickness: 2,
                      color: Colors.black,
                    ),
                    Container(
                      // alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 7),
                      child: Text(
                        'Category: ' + product.type,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 2,
                      thickness: 2,
                      color: Colors.black,
                    ),
                  ],
                ),
                Container(
                  // alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                  child: Text(
                    product.quantity > 0 ? 'Available' : 'Out of stock',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                  child: Text(
                    NumberFormat.currency(locale: 'vi').format(product.price),
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                  child: Text(
                    'Product Information',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  child: Text(
                    product.detail,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(
                  height: 70,
                  color: Colors.transparent,
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
