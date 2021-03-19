import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huy_commerce/IntermediateWidget.dart';

class DateTimeSelector extends StatefulWidget {
  final DateTime dateTime;
  final BuildContext context;

  const DateTimeSelector({Key key, this.dateTime, this.context}) : super(key: key);

  @override
  _DateTimeSelectorState createState() => _DateTimeSelectorState();
}

class _DateTimeSelectorState extends State<DateTimeSelector> {
  DateTime timeToSubmit;

  @override
  void initState() {
    super.initState();
    timeToSubmit = widget.dateTime;
  }

  bool isChanged() {
    return timeToSubmit.day != widget.dateTime.day ||
        timeToSubmit.month != widget.dateTime.month ||
        timeToSubmit.year != widget.dateTime.year;
  }

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).primaryColor;
    var disableColor = Theme.of(context).disabledColor;
    return Container(
      height: 250,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 40,
                width: 100,
                // color: Colors.red,
                child: TextButton(
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: isChanged() ? color : disableColor,
                    ),
                  ),
                  onPressed: isChanged()
                      ? () {
                          submitYesOrNo(
                            context,
                            function: () {
                              FirebaseFirestore.instance
                                  .collection('User')
                                  .doc(FirebaseAuth.instance.currentUser.uid)
                                  .set({
                                'Birth': Timestamp.fromDate(timeToSubmit)
                              }, SetOptions(merge: true));
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(widget.context).showSnackBar(
                                SnackBar(
                                  content: Text('Saved your information'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                          );
                        }
                      : null,
                ),
              ),
              Container(
                height: 40,
                width: 100,
                // color: Colors.red,
                child: TextButton(
                  child: Text(
                    'Cancel',
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
          Container(
            // color: Colors.blue,
            height: 200,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: widget.dateTime,
              maximumDate: DateTime.now(),
              minimumDate: DateTime.now().subtract(Duration(days: 36600)),
              minimumYear: 1930,
              maximumYear: DateTime.now().year,
              onDateTimeChanged: (time) {
                setState(() {
                  timeToSubmit = time;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
