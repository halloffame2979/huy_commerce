import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huy_commerce/Authenticate/AuthenticateComponent.dart';
import 'package:huy_commerce/Buttons/ChangePasswordButton.dart';
import 'package:huy_commerce/IntermediateWidget.dart';
import 'package:huy_commerce/Service/UserService.dart';
import 'package:huy_commerce/UserInformation/UserBirthday.dart';

import 'GenderSelector.dart';

class UserInformation extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  String name, photo, gender = 'Nam';
  DateTime birth;
  bool changedName = false, changedPhoto = false;
  var _divider30 = Divider(height: 30, color: Colors.transparent);
  var _divider10 = Divider(height: 10, color: Colors.transparent);

  Widget text(String text) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 2 - 150, vertical: 5),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 17,
        ),
      ),
    );
  }

  void updateInfo(BuildContext context) {
    UserService.updateUserInfo({'Name': name, 'Photo': photo});

    setState(() {
      changedPhoto = false;
      changedName = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã lưu thông tin của bạn'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  void initState() {
    name = FirebaseAuth.instance.currentUser.displayName;
    photo = FirebaseAuth.instance.currentUser.photoURL;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _cloudDb = FirebaseFirestore.instance;
    var _user = FirebaseAuth.instance.currentUser;
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Sửa hồ sơ'),
            actions: [
              Builder(
                builder: (context) => MaterialButton(
                  child: Text(
                    'Lưu',
                    style: TextStyle(
                      color: changedName || changedPhoto
                          ? Colors.black
                          : Colors.grey,
                    ),
                  ),
                  onPressed: changedName || changedPhoto
                      ? () {
                          submitYesOrNo(context, function: () {
                            Navigator.of(context).pop();
                            updateInfo(context);
                          });
                        }
                      : null,
                ),
              ),
            ],
          ),
          body: Builder(
            builder: (context) => Center(
              child: ListView(
                children: [
                  _divider30,
                  Container(
                    alignment: Alignment.center,
                    height: 200,
                    child: GestureDetector(
                      onTap: () => showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) => Center(
                              child: Container(
                                  width: MediaQuery.of(context).size.width - 20,
                                  color: Colors.white,
                                  child: Image.asset(
                                      'assets/default_avatar.png')))),
                      child: Stack(
                        children: [
                          ClipOval(
                            child:
                                _user.photoURL == null || _user.photoURL.isEmpty
                                    ? Image.asset('assets/default_avatar.png')
                                    : Image.network(
                                        'https://i.pinimg.com/originals/ee/37/3a/ee373a6e6acd57c465915b9570e0955e.jpg',
                                      ),
                          ),
                          Container(
                            padding: EdgeInsets.all(1),
                            child: Icon(Icons.add_a_photo),
                            decoration: BoxDecoration(
                                color: Colors.grey[350],
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _divider10,
                  text('Email'),
                  Center(
                    child: Container(
                      width: 300,
                      height: 57,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            _user.email,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _divider10,
                  text('Full name'),
                  Container(
                    alignment: Alignment.center,
                    child: UserName(
                      hasLabelText: false,
                      name: name,
                      function: (text) {
                        name = text.trim().replaceAll(RegExp(r'\s+'), ' ');
                        if (name != _user.displayName) {
                          setState(() {
                            changedName = true;
                          });
                        } else {
                          setState(() {
                            changedName = false;
                          });
                        }
                      },
                    ),
                  ),
                  _divider30,
                  FutureBuilder(
                      future: _cloudDb.collection('User').doc(_user.uid).get(),
                      builder: (context, AsyncSnapshot<DocumentSnapshot> snap) {
                        if (snap.hasError)
                          return Center(
                            child: Text('ERROR'),
                          );
                        if (snap.hasData) {
                          var data = snap.data.data();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              UserBirthday(
                                birth: data['Birth'].toDate(),
                              ),
                              GendersSelector(
                                context: context,
                                value: snap.data['Gender'],
                              ),
                            ],
                          );
                        } else
                          return Center(child: CircularProgressIndicator());
                      }),
                  _divider30,
                  ChangePasswordButton(),
                  _divider10,
                  InkWell(
                    splashColor: Theme.of(context).primaryColor,
                    highlightColor: Theme.of(context).primaryColor,
                    onTap: () {
                      submitYesOrNo(context, function: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        FirebaseAuth.instance.signOut();
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 57,
                      child: Text(
                        'Logout',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  _divider10,
                  _divider10,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
