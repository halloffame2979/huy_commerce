import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GendersSelector extends StatefulWidget {
  final String value;
  final Function(String string) function;
  final BuildContext context;

  const GendersSelector({Key key, this.value, this.function, this.context})
      : super(key: key);

  @override
  _GendersSelectorState createState() => _GendersSelectorState();
}

class _GendersSelectorState extends State<GendersSelector> {
  String gender;

  List<String> list = ['Male', 'Female'];

  @override
  void initState() {
    gender = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _cloudDb = FirebaseFirestore.instance;
    var _user = FirebaseAuth.instance.currentUser;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        2,
            (index) => Container(
          width: 150,
          height: 57,
          alignment: Alignment.center,
          child: RadioListTile(
            title: Text(list[index]),
            value: list[index],
            groupValue: gender,
            onChanged: (val) {
              setState(() {
                gender = val;
              });
              _cloudDb
                  .collection('User')
                  .doc(_user.uid)
                  .update({'Gender': val});
              ScaffoldMessenger.of(widget.context).showSnackBar(
                SnackBar(
                  content: Text('Saved your information'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}