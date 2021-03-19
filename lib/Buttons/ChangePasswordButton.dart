import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huy_commerce/UserInformation/ChangePasswordPage.dart';

class ChangePasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        height: 57,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.orange, Colors.yellow]),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Icon(
            Icons.security,
            color: Colors.black,
          ),
          title: Text(
            'Change password',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios_outlined),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChangePasswordPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}
