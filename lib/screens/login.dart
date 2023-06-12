// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:main_project/screens/home.dart';
import 'package:main_project/screens/singUp.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget {
  String ip;
  LoginPage(this.ip);
  UserCredential authResult;
  var myControllerName = TextEditingController();
  var myControllerPassword = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    void checkNameAndPasswordLogin() async {
      var ok = true;
      var text = "";
      try {
        authResult = await auth.signInWithEmailAndPassword(
            email: myControllerName.text.trim(),
            password: myControllerPassword.text.trim());
      } catch (err) {
        String message = 'an error occured, please check your credentials';
        ok = false;

        if (err.toString() != null) {
          print(err);
          print("the error: ");
          print(err.toString());
          ok = false;
          if (err.toString() ==
              "[firebase_auth/invalid-email] The email address is badly formatted.") {
            message = "please enter valid email";
          }
          if (err.toString() ==
              "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
            message =
                "email or password isn't found, please check your eamil and password";
          }
          if (err.toString() ==
              "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
            message =
                "email or password isn't found, please check your eamil and password";
          }
          if (err.toString() ==
              "[firebase_auth/unknown] Given String is empty or null") {
            message = "please enter email and password";
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(context).errorColor));
      }
      //check if user is in data base!
      if (ok) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage()),
        );
      }
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Music Love',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: myControllerName,
                decoration: InputDecoration(
                  labelText: 'email',
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: myControllerPassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: checkNameAndPasswordLogin,
              child: Text('Submit'),
              style: TextButton.styleFrom(
                primary: Colors.blue,
                backgroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => singUpPage(ip)),
                    );
                  },
                  child: Text('Sign Up'),
                  style: TextButton.styleFrom(
                    primary: Colors.blue,
                    backgroundColor: Colors.white,
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Log In'),
                  style: TextButton.styleFrom(
                    primary: Colors.blue,
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
