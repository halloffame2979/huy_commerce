import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:huy_commerce/Authenticate/AuthenticateScreen.dart';
import 'package:huy_commerce/HomeScreen/HomeScreen.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) return HomeScreen();
          return AuthenticateScreen();
        });
  }
}
