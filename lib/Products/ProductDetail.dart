import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huy_commerce/Buttons/AddToCart.dart';
import 'package:huy_commerce/Buttons/BuyNow.dart';
import 'package:huy_commerce/IntermediateWidget.dart';
import 'package:huy_commerce/Model/AvailableProductModel.dart';
import 'package:intl/intl.dart';

import 'ImageSlide.dart';

class ProductDetail extends StatefulWidget {
  final String productID;

  const ProductDetail({Key key, this.productID}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  Future<Map> fetch;

  Future<Map> fetchProduct() async {
    var rawProduct = (await FirebaseFirestore.instance
        .collection('Product')
        .doc(widget.productID)
        .get());

    var url = [];
    for (var image in rawProduct.data()['Image']) {
      url.add(await FirebaseStorage.instance.ref(image).getDownloadURL());
    }
    var product = rawProduct.data();
    product['ID'] = widget.productID;
    product['Image'] = url;

    return product;
  }

  @override
  void initState() {
    super.initState();
    fetch = fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: AddToCart(productID: widget.productID),
            ),
            Container(
              width: 1,
              height: 0,
            ),
            Expanded(
              child: BuyNow(productID: widget.productID),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: FutureBuilder(
          future: fetch,
          builder: (context, AsyncSnapshot<Map> snap) {
            if (snap.hasError) return ErrorMessage();
            if (snap.connectionState == ConnectionState.done) {
              Map map = snap.data;
              var product = AvailableProductModel.fromJson(map);
              return CustomScrollView(
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
                      ProductInCart(
                        isBlack: true,
                      ),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 7, vertical: 10),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 7, vertical: 10),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                        child: Text(
                          NumberFormat.currency(locale: 'vi')
                              .format(product.price),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 7, vertical: 10),
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
              );
            }
            return Loading();
          },
        ),
      ),
    );
  }
}
