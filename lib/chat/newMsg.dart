import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  final String userID1;
  final String userID2;

  const NewMessage(this.userID1, this.userID2);

  NewMessageState createState() => NewMessageState(this.userID1, this.userID2);
}

class NewMessageState extends State<NewMessage> {
  final controller = new TextEditingController();
  final String userID1;
  final String userID2;

  NewMessageState(this.userID1, this.userID2);

  var enterMsg = "";

  void sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance
        .collection('speChats/all-chats/' +
            userID1.substring(0, 4) +
            userID2.substring(0, 4))
        .add({
      'text': enterMsg,
      'createdAt': Timestamp.now(),
      'userID': user.uid,
      'username': userData['username'],
    });
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(labelText: 'Send a new message...'),
              onChanged: (value) {
                setState(() {
                  enterMsg = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(Icons.send),
            onPressed: enterMsg.trim().isEmpty ? null : sendMessage,
          )
        ],
      ),
    );
  }
}
