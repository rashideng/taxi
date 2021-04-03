import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:taxi/AllScreens/mainscreen.dart';
import 'package:taxi/AllScreens/registrationScreen.dart';
import 'package:taxi/AllWidgets/progressDialog.dart';
import 'package:taxi/main.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  static const String idscreen = "Login";
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Image(
                image: AssetImage("images/r_taxi.png"),
                width: 200,
                height: 300,
                alignment: Alignment.center,
              ),
            ),
            Text(
              "Login as a Rider",
              style: TextStyle(fontSize: 24, fontFamily: "Brand Bold"),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextField(
                    controller: emailTextEditingController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(fontSize: 18),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: passwordTextEditingController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(fontSize: 18),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),

                  // ignore: deprecated_member_use
                  RaisedButton(
                    color: Colors.black,
                    textColor: Colors.white,
                    child: Container(
                      height: 50,
                      width: 200,
                      child: Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontFamily: "Brand Bold",
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    onPressed: () {
                      if (!emailTextEditingController.text.contains("@")) {
                        displayToastMessage("Email is not valid", context);
                      } else if (passwordTextEditingController.text.isEmpty) {
                        displayToastMessage(
                            "Password field cant be empty", context);
                      } else {
                        loginAndAuthenticateUser(context);
                      }
                    },
                  ),
                ],
              ),
            ),
            // ignore: deprecated_member_use
            FlatButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RegistrationScreen.idscreen, (route) => false);
                },
                child: Text(
                  "Do not have an account? Register Here",
                  style: TextStyle(fontSize: 18),
                ))
          ],
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginAndAuthenticateUser(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ProgressDialog(
          messages: "Authenticating, Please wait...",
        );
      },
    );

    final User firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Error:" + errMsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) {
      //save user info to Data base

      userRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.idscreen, (route) => false);
          displayToastMessage("You are Logged in", context);
        } else {
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToastMessage(
              "No Records for this user. Please create a nw account", context);
        }
      });
      displayToastMessage(
          "Congratulations, Your account has been created.", context);
    } else {
      Navigator.pop(context);
      //error occourd - Display Error message
      displayToastMessage("Error occured,Can not be Sign in", context);
    }
  }
}
