import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:main_project/chat/message_bubble.dart';

class messages extends StatelessWidget {
  final String userID1;
  final String userID2;

  const messages(this.userID1, this.userID2);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('speChats/all-chats/' +
                  userID1.substring(0, 4) +
                  userID2.substring(0, 4))
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (ctx, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatDocs = chatSnapshot.data.docs;
            return ListView.builder(
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (ctx, index) => messageBubble(
                chatDocs[index]['text'],
                chatDocs[index]['userID'] ==
                    FirebaseAuth.instance.currentUser.uid,
                chatDocs[index]['username'],
                key: ValueKey(chatDocs[index].id),
              ),
            );
          },
        );
      },
    );
  }
}
