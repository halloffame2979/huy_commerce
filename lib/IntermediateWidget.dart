import 'package:flutter/material.dart';

Future submitYesOrNo(BuildContext context, {Function function}) {
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Xác nhận?'),
      actions: [
        FlatButton(
          color: Theme.of(context).primaryColor,
          child: Container(
            child: Text('Có'),
            height: 20,
          ),
          onPressed: function,
        ),
        FlatButton(
          color: Colors.grey[200],
          child: Container(
            child: Text(
              'Không',
              style: TextStyle(color: Colors.black),
            ),
            height: 20,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
    barrierDismissible: true,
  );
}