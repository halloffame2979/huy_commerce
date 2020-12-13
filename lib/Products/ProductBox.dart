import 'package:flutter/material.dart';
import 'package:huy_commerce/Model/ProductModel.dart';
import 'package:huy_commerce/Products/ProductDetail.dart';
import 'package:intl/intl.dart';

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
    var product = Product(
        '',
        'https://png2.cleanpng.com/sh/b25f73decee996f0daa8c494ce4d4d9c/L0KzQYm3WcE4N5Noh5H0aYP2gLBuTf1mdqQyedZyZHH2PcbzlQJiNZN0hAV9LUKwg7BsgftmeqQyedZyZHH2PcbzlQJial46eqtvNnG6Q7a7WMFnQV88T6oEOUKzRoK8U8cyP2U2S6MEM0axgLBu/kisspng-mens-adidas-ultra-boost-2-sneakers-adidas-ultrab-5b9f6a73e481f9.778992061537174131936.png',
        'Ultraboost',
        4000000,
        'Limited');
    var img = Image.network(
      product.image,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.low,
    );
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
              child: img,
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
