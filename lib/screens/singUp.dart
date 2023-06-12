// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:main_project/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main_project/screens/songSelect.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class singUpPage extends StatelessWidget {
  String ip;
  singUpPage(this.ip);
  @override
  var myControllerName = TextEditingController();
  var myControllerUserName = TextEditingController();
  var myControllerPassword = TextEditingController();
  var myControllerReEnterPassword = TextEditingController();
  final auth = FirebaseAuth.instance;
  Widget build(BuildContext context) {
    UserCredential authResult;
    void checkNameAndPasswordSingUp() async {
      var ok = true;
      String answer = "";
      if (myControllerUserName.text.length > 3) {
        if (myControllerReEnterPassword.text == myControllerPassword.text) {
          try {
            authResult = await auth.createUserWithEmailAndPassword(
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
                  "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
                message =
                    "the email address is already in use by another account";
              }
              if (err.toString() ==
                  "[firebase_auth/unknown] Given String is empty or null") {
                message = "please enter email and password";
              }
              if (err.toString() ==
                  "[firebase_auth/weak-password] Password should be at least 6 characters") {
                message = "Password should be at least 6 characters";
              }
            }
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(message),
                backgroundColor: Theme.of(context).errorColor));
          }
        } else {
          ok = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("passwords not match"),
              backgroundColor: Theme.of(context).errorColor));
        }
      } else {
        ok = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("username must be at least 4 charecters"),
            backgroundColor: Theme.of(context).errorColor));
      }

      if (ok) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user?.uid)
            .set({'username': myControllerUserName.text});
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SongSelectionPage(ip)),
        );
      }
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Music Love',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: myControllerName,
              decoration: InputDecoration(
                labelText: 'email',
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: myControllerUserName,
              decoration: InputDecoration(
                labelText: 'username',
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: myControllerPassword,
              decoration: InputDecoration(
                labelText: 'password',
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: myControllerReEnterPassword,
              decoration: InputDecoration(
                labelText: 're-enter password',
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: checkNameAndPasswordSingUp,
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
                onPressed: () {},
                child: Text('Sign Up'),
                style: TextButton.styleFrom(
                  primary: Colors.blue,
                  backgroundColor: Colors.white,
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage(ip)),
                  );
                },
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
    );
  }
}
