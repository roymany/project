import 'dart:async';
import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  final int currentTime;
  TimerWidget(this.currentTime);
  @override
  _TimerWidgetState createState() => _TimerWidgetState(this.currentTime);
}

class _TimerWidgetState extends State<TimerWidget> {
  int currentTime;
  _TimerWidgetState(this.currentTime);
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (currentTime > 0) {
          currentTime--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String minutes = (currentTime ~/ 60).toString().padLeft(2, '0');
    String seconds = (currentTime % 60).toString().padLeft(2, '0');
    return Container(
      child: Text(
        '$minutes:$seconds',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
