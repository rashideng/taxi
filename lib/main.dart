import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:taxi/AllScreens/loginscreen.dart';
import 'package:taxi/AllScreens/mainscreen.dart';
import 'package:taxi/AllScreens/registrationScreen.dart';

import 'AllScreens/loginscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

DatabaseReference userRef =
    FirebaseDatabase.instance.reference().child("users");

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'R Taxi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: LoginScreen.idscreen,
      routes: {
        RegistrationScreen.idscreen: (context) => RegistrationScreen(),
        LoginScreen.idscreen: (context) => LoginScreen(),
        MainScreen.idscreen: (context) => MainScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
