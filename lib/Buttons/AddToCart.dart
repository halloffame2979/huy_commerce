import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huy_commerce/Products/QuantitySelector.dart';

class AddToCart extends StatelessWidget {
  final String productID;

  const AddToCart({Key key, this.productID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomLeft,
          colors: [Colors.orangeAccent, Colors.yellow],
        ),
      ),
      child: MaterialButton(
        disabledColor: Colors.grey,
        height: 60,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => QuantitySelector(
              name: 'Add to Cart',
              productID: productID,
            ),
            //builder: (context) => QuantityChanger()
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_shopping_cart),
            Text('Add to Cart'),
          ],
        ),
      ),
    );
  }
}
