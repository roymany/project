import 'package:flutter/material.dart';
import 'package:main_project/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:web_socket_channel/io.dart';

class SongSelectionPage extends StatefulWidget {
  @override
  SongSelectionPage();

  SongSelectionPageState createState() => SongSelectionPageState();
}

class SongSelectionPageState extends State<SongSelectionPage> {
  SongSelectionPageState();

  List<String> allSongs = [];

  List<String> selectedSongs = [];
  var songToUploadController = TextEditingController();

  String filterText = '';

  void uploadSong(String songToUpload) {
    var channel = IOWebSocketChannel.connect("ws://10.100.102.25:8820");
    channel.sink.add(songToUpload);
    channel.sink.close();
  }

  Future<List<String>> getAllSongs() async {
    ListResult result = await FirebaseStorage.instance.ref().listAll();
    List<String> fallSongs = [];
    result.items.forEach((ref) {
      String song = ref.fullPath;
      fallSongs.add(song.substring(0, song.length - 4));
    });
    return fallSongs;
  }

  List<String> getFilteredSongs() {
    print(allSongs);
    return allSongs
        .where(
            (song) => song.toLowerCase().startsWith(filterText.toLowerCase()))
        .toList();
  }

  Widget buildSongList() {
    final filteredSongs = getFilteredSongs();
    return ListView.builder(
      itemCount: filteredSongs.length,
      itemBuilder: (BuildContext context, int index) {
        final song = filteredSongs[index];
        return ListTile(
          title: Text(song),
          tileColor: selectedSongs.contains(song) ? Colors.blue : null,
          onTap: () {
            if (selectedSongs.length < 5) {
              if (selectedSongs.contains(song)) {
                setState(() {
                  print("removing");
                  selectedSongs.remove(song);
                });
              } else {
                setState(() {
                  print("adding");
                  selectedSongs.add(song);
                });
              }
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Your Favorite Songs'),
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(
                      255, 150, 7, 179), // Set the button's background color
                  onPrimary: Colors.white, // Set the text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Upload Song"),
                        content: Column(
                          children: [
                            Text(
                                "Please write us the name of a song you want to upload and we will try to upload it :)"),
                            SizedBox(height: 10),
                            TextField(
                              controller: songToUploadController,
                              decoration: InputDecoration(
                                labelText: 'Song Name...',
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              child: Text('Send'),
                              onPressed: () {
                                if (songToUploadController.text.trim() != "") {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Thanks! we got your song"),
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                    ),
                                  );
                                  uploadSong(
                                      songToUploadController.text.trim());
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "Please enter the name of the song"),
                                      backgroundColor:
                                          Theme.of(context).errorColor,
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: Text('back'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Upload Song'),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.upload,
                      size: 24.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          TextField(
            onChanged: (text) {
              setState(() {
                filterText = text;
              });
            },
            decoration: InputDecoration(
              hintText: 'Filter songs',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          FutureBuilder(
            future: getAllSongs(),
            builder: (ctx, futureSnapshot) {
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              allSongs = futureSnapshot.data;
              return Expanded(
                child: buildSongList(),
              );
            },
          ),
          if (selectedSongs.length == 5)
            ElevatedButton(
              onPressed: () async {
                final user = await FirebaseAuth.instance.currentUser;
                final userID = user.uid;
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userID)
                    .update({
                  'song1': selectedSongs[0],
                  'song2': selectedSongs[1],
                  'song3': selectedSongs[2],
                  'song4': selectedSongs[3],
                  'song5': selectedSongs[4],
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => nextPage()),
                );
              },
              child: Text('Next'),
            ),
        ],
      ),
    );
    // return a widget here (you have to return a widget to the builder)
  }
}
