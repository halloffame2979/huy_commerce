import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'DateTimeSelector.dart';

class UserBirthday extends StatelessWidget {
  final DateTime birth;

  const UserBirthday({Key key, this.birth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _color = Theme.of(context).primaryColor;
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => DateTimeSelector(
            context: context,
            dateTime: birth,
          ),
        );
      },
      child: Container(
        width: 300,
        height: 60,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
          border: Border.all(color: _color, width: 1.5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            Container(
              alignment: Alignment.centerRight,
              child: Icon(Icons.edit),
            ),
            Center(
              child: Container(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    birth != null ? DateFormat('dd/MM/yyyy').format(birth) : '',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
