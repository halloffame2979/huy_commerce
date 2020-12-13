import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserModel extends ChangeNotifier {
  String _bufferedName;
  String _bufferedPhoto;
  bool _changedName = false;
  bool _changedPhoto = false;

  var user = FirebaseAuth.instance.currentUser;

  String get bufferedName => _bufferedName;

  set bufferedName(String value) {
    _bufferedName = value;
    if (_bufferedName != user.displayName)
      changedName = true;
    else
      changedName = false;
    notifyListeners();
  }

  String get bufferedPhoto => _bufferedPhoto;

  set bufferedPhoto(String value) {
    _bufferedPhoto = value;
    if (_bufferedPhoto != user.photoURL)
      changedPhoto = true;
    else
      changedPhoto = false;
    notifyListeners();
  }

  bool get changedName => _changedName;

  set changedName(bool value) {
    _changedName = value;
    notifyListeners();
  }

  bool get changedPhoto => _changedPhoto;

  set changedPhoto(bool value) {
    _changedPhoto = value;
    notifyListeners();
  }

}
