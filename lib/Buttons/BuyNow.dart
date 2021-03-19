import 'package:flutter/material.dart';
import 'package:huy_commerce/Products/QuantitySelector.dart';

class BuyNow extends StatelessWidget {
  final String productID;

  const BuyNow({Key key, this.productID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      child: MaterialButton(
        disabledColor: Colors.grey,
        height: 60,
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) => QuantitySelector(
                    name: 'Buy Now',
                    productID: productID,
                  ));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag),
            Text('Buy Now'),
          ],
        ),
      ),
    );
  }
}
