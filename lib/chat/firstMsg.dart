import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:main_project/screens/chat.dart';

class firstConnection extends StatelessWidget {
  final String userID;

  const firstConnection(this.userID);
  @override
  Widget build(BuildContext context) {
    String song = "";
    return Container(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('chats').snapshots(),
          builder: (ctx, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              // ignore: prefer_const_constructors
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (streamSnapshot.hasError) {
              print("stream ha error first msg:");
              print(streamSnapshot.error);
            }
            final docs = streamSnapshot.data.docs;
            var x = Container();
            if (docs != null) {
              docs.forEach(
                (document) {
                  if (document.id == userID) {
                    final tt = new Timer(Duration(minutes: 1), () {
                      FirebaseFirestore.instance
                          .collection('chats')
                          .doc(userID)
                          .delete();
                    });
                    x = Container(
                      width: 300,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'someone want to chat with you',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  tt.cancel();
                                  String userID2 = "";
                                  final chatDocSnapshot =
                                      await FirebaseFirestore.instance
                                          .collection('chats')
                                          .doc(userID)
                                          .get();
                                  userID2 = chatDocSnapshot.data()['firstMsg'];
                                  song = chatDocSnapshot.data()['selectedSong'];
                                  await FirebaseFirestore.instance
                                      .collection('chats')
                                      .doc(userID)
                                      .update({'allowPress': 'True'});
                                  FirebaseFirestore.instance
                                      .collection('chats')
                                      .doc(userID)
                                      .delete();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          chatScreeen(userID, userID2, song),
                                    ),
                                  );
                                },
                                child: Text('allow'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  tt.cancel();
                                  await FirebaseFirestore.instance
                                      .collection('chats')
                                      .doc(userID)
                                      .update({'denayPress': 'True'});
                                  FirebaseFirestore.instance
                                      .collection('chats')
                                      .doc(userID)
                                      .delete();
                                },
                                child: Text('denay'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                },
              );
            }
            return x;
          }),
    );
  }
}
