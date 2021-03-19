import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuantityChanger extends StatefulWidget {
  final Function(int) function;
  final int initQuantity;

  const QuantityChanger({Key key, this.function, this.initQuantity})
      : super(key: key);

  @override
  _QuantityChangerState createState() => _QuantityChangerState();
}

class _QuantityChangerState extends State<QuantityChanger> {
  int quantity;
  var controller = TextEditingController();

  void initState() {
    super.initState();
    quantity = widget.initQuantity ?? 1;
    controller.text = quantity.toString();
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length));
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: IconButton(
                disabledColor: Colors.grey,
                icon: Icon(Icons.remove),
                onPressed: quantity <= 1
                    ? null
                    : () {
                  setState(() {
                    quantity -= 1;
                    controller.text = quantity.toString();
                    controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: controller.text.length));
                  });
                  widget.function(quantity);
                }),
          ),
          Container(
            height: 20,
            width: 50,
            child: TextField(
              controller: controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 2,
              decoration: InputDecoration(
                counterText: '',
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.deny(RegExp(r'^0+'))
              ],
              onChanged: (val) {
                print(val);
                if (val.isEmpty) {
                  controller.text = '0';
                  controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: controller.text.length));
                  setState(() {
                    quantity = 0;
                  });
                  widget.function(quantity);
                  return;
                }

                setState(() {
                  quantity = int.parse(val);
                });
                widget.function(quantity);
              },
            ),
          ),
          Container(
            child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    quantity += 1;
                    controller.text = quantity.toString();
                    controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: controller.text.length));
                  });
                  widget.function(quantity);
                }),
          ),
        ],
      ),
    );
  }
}