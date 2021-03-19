import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

var _user = FirebaseAuth.instance.currentUser;
var _auth = FirebaseAuth.instance;
var _cloudDb = FirebaseFirestore.instance;

class UserService {
  static Future<void> createUser(
      String email, String password, String name, String gender,
      {Function(FirebaseException e) errorHandle}) async {
    try {
      await Firebase.initializeApp(
          name: 'SecondApp', options: Firebase.app().options);
    } catch (e) {}
    try {
      var _auth = FirebaseAuth.instanceFor(app: Firebase.app('SecondApp'));
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _auth.currentUser.updateProfile(displayName: name);
      await _auth.currentUser.sendEmailVerification();
      _cloudDb.collection('User').doc(_auth.currentUser.uid).set({
        'Gender': gender,
        'Birth': Timestamp.fromDate(DateTime(1970, 1, 1)),
        'Order': ''
      });
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      errorHandle(e);
    }
  }

  static Future<void> logIn(String email, String password,
      {Function(FirebaseException e) errorHandle}) async {
    var auth = FirebaseAuth.instance;
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      errorHandle(e);
    }
  }

  static Future<void> logOut() async {
    _auth.signOut();
  }

  static Future<void> updateUserInfo(Map<String, dynamic> info) async {
    var name = info['Name'];
    String photo = info['Photo'];
    if (name != null) _user.updateProfile(displayName: name);
    if (photo != null && photo.isNotEmpty) _user.updateProfile(photoURL: photo);
  }

  static Future reauthenticateUser(String currentPassword) async {
    var credential = EmailAuthProvider.credential(
        email: _user.email, password: currentPassword);
    await _user.reauthenticateWithCredential(credential);
  }

  static Future changePassword(String currentPassword, String newPassword,
      {Function(FirebaseException exception) errorHandle}) async {

    try {
      await reauthenticateUser(currentPassword);
      await _user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      errorHandle(e);
    }
  }

  static Future forgetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
