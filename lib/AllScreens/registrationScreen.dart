import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:taxi/AllScreens/loginscreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taxi/AllScreens/mainscreen.dart';
import 'package:taxi/AllWidgets/progressDialog.dart';
import 'package:taxi/main.dart';

// ignore: must_be_immutable
class RegistrationScreen extends StatelessWidget {
  static const String idscreen = "register";
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
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
              "Register as a Rider",
              style: TextStyle(fontSize: 24, fontFamily: "Brand Bold"),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextField(
                    controller: nameTextEditingController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Full Nmae",
                      labelStyle: TextStyle(fontSize: 18),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 15,
                  ),
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
                    controller: phoneTextEditingController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Phone",
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
                          "Register",
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
                      if (nameTextEditingController.text.length < 3) {
                        displayToastMessage(
                            "Name Must be atleast 4 characters", context);
                      } else if (!emailTextEditingController.text
                          .contains("@")) {
                        displayToastMessage("Email is not valid", context);
                      } else if (phoneTextEditingController.text.isEmpty) {
                        displayToastMessage("Phone number is rquired", context);
                      } else if (passwordTextEditingController.text.length <
                          6) {
                        displayToastMessage(
                            "Password Must be atleast 8 characters", context);
                      } else {
                        registerNewUser(context);
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
                      context, LoginScreen.idscreen, (route) => false);
                },
                child: Text(
                  "Already have an account? Login Here",
                  style: TextStyle(fontSize: 18),
                ))
          ],
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void registerNewUser(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ProgressDialog(
          messages: "Registering, Please wait...",
        );
      },
    );
    final User firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Error:" + errMsg.toString(), context);
    }))
        .user;
    if (firebaseUser != null) {
      //save user info to Data base

      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      userRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage(
          "Congratulations, Your account has been created.", context);
      Navigator.pushNamedAndRemoveUntil(
          context, MainScreen.idscreen, (route) => false);
    } else {
      Navigator.pop(context);
      //error occourd - Display Error message
      displayToastMessage("New user account has not be created", context);
    }
  }
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
