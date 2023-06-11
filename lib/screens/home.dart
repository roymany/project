import 'dart:async';

import 'package:flutter/material.dart';
import 'package:main_project/chat/firstMsg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main_project/screens/chat.dart';

class nextPage extends StatefulWidget {
  nextPage();
  @override
  _nextPage createState() => _nextPage();
}

class _nextPage extends State<nextPage> {
  final String userID = FirebaseAuth.instance.currentUser.uid;
  bool alreadyPressed = false;
  _nextPage();
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> event;
  @override
  void dispose() {
    if (event != null) event.cancel();
    print('cancel streammm');
  }

  void connectUser(String song, String idOfMatchUser, final docSnapshot) async {
    await Future.delayed(Duration(milliseconds: 1500));
    if (docSnapshot.exists) {
      print("doc exsist");
      print("heyy " + song);
      if (docSnapshot.data().containsKey('allowPress')) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => chatScreeen(idOfMatchUser, userID, song),
          ),
        );
        dispose();
        setState(() {
          alreadyPressed = false;
        });
        return;
      }
    } else {
      //if user not responding
      print("doc not exsist");
      dispose();
      setState(() {
        alreadyPressed = false;
      });
      return;
    }
  }

  void matchPressed(String song, BuildContext context) async {
    setState(() {
      alreadyPressed = true;
    });
    bool findMatch = false;
    String idOfMatchUser =
        " "; //  מוצא את הID של היוזר שהוא רוצה לשלוח אליו הודעה
    final userDocSnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    final allDocs = userDocSnapshot.docs.toList();
    allDocs.forEach((doc) {
      if (doc.id != userID) {
        if (doc.get('song1') == song) {
          findMatch = true;
          idOfMatchUser = doc.id;
        } else if (doc.get('song2') == song) {
          findMatch = true;
          idOfMatchUser = doc.id;
        } else if (doc.get('song3') == song) {
          findMatch = true;
          idOfMatchUser = doc.id;
        } else if (doc.get('song4') == song) {
          findMatch = true;
          idOfMatchUser = doc.id;
        } else if (doc.get('song5') == song) {
          findMatch = true;
          idOfMatchUser = doc.id;
        }
      }
    });
    if (findMatch == true) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Match Status"),
            content: Text(
                "we found you a match, please wait a few seconds to see if the user is available to chat right now"),
            actions: [
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
      FirebaseFirestore.instance
          .collection('chats')
          .doc(idOfMatchUser)
          .set({"firstMsg": userID, "selectedSong": song});
      // ignore: unrelated_type_equality_checks
      event = FirebaseFirestore.instance
          .collection('chats')
          .doc(idOfMatchUser)
          .snapshots()
          .listen(
              (docSnapshot) => connectUser(song, idOfMatchUser, docSnapshot));
    } else {
      setState(() {
        alreadyPressed = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Match Status"),
            content: Text(
                "sorry, we couldn't find someone that match with this song"),
            actions: [
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
        title: Text('My Page'),
      ),
      body: FutureBuilder(
          future:
              FirebaseFirestore.instance.collection('users').doc(userID).get(),
          builder: (ctx, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final song1 = futureSnapshot.data['song1'];
            final song2 = futureSnapshot.data['song2'];
            final song3 = futureSnapshot.data['song3'];
            final song4 = futureSnapshot.data['song4'];
            final song5 = futureSnapshot.data['song5'];
            return ListView(children: [
              _buildListItem(context, song1),
              _buildListItem(context, song2),
              _buildListItem(context, song3),
              _buildListItem(context, song4),
              _buildListItem(context, song5),
              firstConnection(userID)
            ]);
          }),
    );
  }

  Widget _buildListItem(BuildContext context, String text) {
    return ListTile(
      title: Text(
        text,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(250, 7, 28, 219),
        ),
      ),
      trailing: ElevatedButton(
        onPressed: () => alreadyPressed ? {} : matchPressed(text, context),
        child: Text('Match'),
        style: TextButton.styleFrom(
          primary: Colors.blue,
          backgroundColor: Colors.white,
        ),
      ),
      visualDensity: VisualDensity(vertical: 4),
    );
  }
}
