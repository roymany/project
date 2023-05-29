import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class MyAudioPlayer extends StatefulWidget {
  @override
  _MyAudioPlayerState createState() => _MyAudioPlayerState();
}

class _MyAudioPlayerState extends State<MyAudioPlayer> {
  AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
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

  Future<void> _playAudio(String audioUrl) async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() => _isPlaying = false);
    } else {
      final file = await _downloadFile(audioUrl, audioUrl);
      await _audioPlayer.play(file.path, isLocal: true);
      setState(() => _isPlaying = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: IconButton(
        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
        onPressed: () => _playAudio('song.mp3'),
      ),
    );
  }
}
