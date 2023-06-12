import 'package:flutter/material.dart';
import 'package:main_project/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';

class ServerIpScreen extends StatefulWidget {
  @override
  _ServerIpScreenState createState() => _ServerIpScreenState();
}

class _ServerIpScreenState extends State<ServerIpScreen> {
  TextEditingController _ipController = TextEditingController();

  bool validateIpAddress(String ip) {
    final pattern = r'^(\d{1,3}\.){3}\d{1,3}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(ip);
  }

  void submitServerId() {
    String ip = _ipController.text.trim();
    if (validateIpAddress(ip)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage(ip)),
      );
      print('Submitted Server IP: $ip');
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid IP Address'),
            content: Text('Please enter a valid IP address'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Server ID'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'HI, please write server id',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _ipController,
              decoration: InputDecoration(
                labelText: 'Server IP',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: submitServerId,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
