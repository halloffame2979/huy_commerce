import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:huy_commerce/Authenticate/AuthenticateComponent.dart';
import 'package:huy_commerce/IntermediateWidget.dart';
import 'package:huy_commerce/Service/UserService.dart';
import 'package:intl/intl.dart';

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
    Scaffold.of(context).showSnackBar(
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
                builder: (context) => FlatButton(
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
                  text('Họ và tên'),
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
                  StreamBuilder(
                      stream: _cloudDb
                          .collection('User')
                          .doc(_user.uid)
                          .snapshots(),
                      builder: (context, AsyncSnapshot<DocumentSnapshot> snap) {
                        if (snap.hasError)
                          return Center(
                            child: Text('ERROR'),
                          );
                        if (snap.hasData) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Container(
                                  width: 300,
                                  height: 57,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        DateFormat('dd/MM/yyyy').format(
                                            snap.data['Birth'].toDate()),
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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
                  Center(
                    child: Container(
                      width: 300,
                      height: 57,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.red, Colors.orange, Colors.yellow]),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.security,
                          color: Colors.black,
                        ),
                        title: Text(
                          'Đổi mật khẩu',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios_outlined),
                        onTap: () {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => Scaffold(),
                          //   ),
                          // );
                          print(_user.uid);
                        },
                      ),
                    ),
                  ),
                  _divider10,
                  InkWell(
                    splashColor: Theme.of(context).primaryColor,
                    highlightColor: Theme.of(context).primaryColor,
                    onTap: () {
                      submitYesOrNo(context, function: () {
                        Navigator.of(context).pop();
                        FirebaseAuth.instance.signOut();
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 57,
                      child: Text(
                        'Đăng xuất',
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

  List<String> list = ['Nam', 'Nữ'];

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
              gender = val;
              _cloudDb
                  .collection('User')
                  .doc(_user.uid)
                  .update({'Gender': val});
              Scaffold.of(widget.context).showSnackBar(
                SnackBar(
                  content: Text('Đã lưu giới tính của bạn'),
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
