// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:main_project/chat/messages.dart';
import 'package:main_project/chat/newMsg.dart';
import 'package:main_project/chat/timer.dart';

class chatScreeen extends StatefulWidget {
  final String userID1;
  final String userID2;
  final String song;
  chatScreeen(this.userID1, this.userID2, this.song);
  @override
  _chatScreeenState createState() =>
      _chatScreeenState(this.userID1, this.userID2, this.song);
}

class _chatScreeenState extends State<chatScreeen> {
  Timer _timer;
  final String userID1;
  final String userID2;
  final String song;
  AudioPlayer _audioPlayer = AudioPlayer();
  int totalDuration;
  Duration myDuration = Duration(days: 5);
  Timer countdownTimer;
  _chatScreeenState(this.userID1, this.userID2, this.song);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
  }

  Future<File> _downloadFile(String url, String filename) async {
    final ref = FirebaseStorage.instance.ref().child(url);
    final file = File('${(await getTemporaryDirectory()).path}/$filename');
    await ref.writeToFile(file);
    return file;
  }

  Future<int> _playAudio(String audioUrl) async {
    final file = await _downloadFile(audioUrl, audioUrl);
    await _audioPlayer.play(file.path, isLocal: true);
    await Future.delayed(Duration(milliseconds: 1000));
    totalDuration = await _audioPlayer.getDuration();
    return totalDuration;
  }

  Widget build(BuildContext context) {
    print(song);
    return FutureBuilder(
      future: _playAudio(song + ".mp3"),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        int time = futureSnapshot.data;
        time = time ~/ 1000;
        Future.delayed(Duration(seconds: time), () {
          _audioPlayer.dispose();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Match Status"),
                  content: Text(
                      "Your time is up :) , would you like to keep chating or move to the next person?"),
                  actions: [
                    Row(children: [
                      TextButton(
                        child: Text('STAY'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('MOVE'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      ),
                    ])
                  ],
                );
              });
        });
        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Meet Each Other'),
                Icon(
                  Icons.favorite,
                  color: Colors.pink,
                  size: 24.0,
                ),
              ],
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                _audioPlayer.stop();
                _audioPlayer.dispose();
                Navigator.of(context).pop();
              },
            ),
          ),
          body: Container(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: TimerWidget(time),
                ),
                Expanded(
                  child: messages(userID1, userID2),
                ),
                NewMessage(userID1, userID2)
              ],
            ),
          ),
        );
      },
    );
  }
}
