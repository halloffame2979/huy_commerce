import 'package:flutter/material.dart';
import 'package:huy_commerce/Model/ProductModel.dart';

class ProductDetail extends StatelessWidget {
  final Product product;

  const ProductDetail({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          controller: ScrollController(),
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              expandedHeight: 50,
              floating: true,
              // flexibleSpace: Image.network(product.image),
              pinned: true,
            ),
            SliverAppBar(
                backgroundColor: Colors.transparent,
                expandedHeight: MediaQuery.of(context).size.width,
                // floating: true,
                flexibleSpace: Image.network(product.image)
                // pinned: true,
                ),
            SliverList(
                delegate: SliverChildListDelegate.fixed(
              List.generate(
                  10,
                  (index) => Column(
                        children: [
                          Container(
                            height: 100,
                            child: Text(product.name),
                          ),
                          Container(
                            height: 100,
                            child: Text(product.detail),
                          ),
                        ],
                      )),
            )),
          ],
        ),
      ),
    );
  }
}
