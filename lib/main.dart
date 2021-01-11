import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huy_commerce/LandingPage.dart';
import 'package:huy_commerce/Model/UserModel.dart';
import 'package:huy_commerce/TestWidget.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserModel()),
      ],
      child: MaterialApp(
        title: "HSCom",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
          primaryColor: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          accentColor: Colors.orange,
        ),
        home: LandingPage(),
         //TestWidget(),
      ),
    );
  }
}
