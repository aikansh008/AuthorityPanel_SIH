import 'package:authority_panel/repositoy/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';


class IssuesScreen extends StatefulWidget {
  final UserModel user;

  IssuesScreen({
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  _IssuesScreenState createState() => _IssuesScreenState();
}

class _IssuesScreenState extends State<IssuesScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _playingUrl;

  Future<List<Map<String, dynamic>>> _fetchRecordings() async {
    try {
      print('Fetching recordings for userId: ${widget.user.id}');

      var recordingsRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.user.id)
          .collection('recordings');

      QuerySnapshot querySnapshot = await recordingsRef.get();

      print('Number of documents fetched: ${querySnapshot.docs.length}');

      if (querySnapshot.docs.isEmpty) {
        print('No recordings found.');
      }

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Failed to fetch recordings: $e');
      throw e; // Throw the error to be caught by FutureBuilder
    }
  }

  void _playAudio(String url) async {
    if (_playingUrl != url) {
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(url));
      setState(() {
        _playingUrl = url;
      });
    } else {
      await _audioPlayer.pause();
      setState(() {
        _playingUrl = null;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(192, 119, 33, 1.0),
        title: Text(widget.user.school,
            style: TextStyle(fontSize: 20, color: Colors.white)),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchRecordings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No recordings found.'));
          }

          List<Map<String, dynamic>> recordings = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: recordings.length,
              itemBuilder: (context, index) {
                var recording = recordings[index];
                String url = recording['url'] ?? '';
                
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:const Color.fromARGB(255, 20, 73, 116),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: ListTile(
                       tileColor: Colors.blue[50], // Background color of the tile
                     
                    title: Text('Recording ${index + 1}'),
                    subtitle: Text(
                        'Timestamp: ${(recording['timestamp'] as Timestamp).toDate().toString()}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    trailing: IconButton(
                      icon: Icon(
                        
                        color: Color.fromRGBO(192, 119, 33, 1.0),
                        size:40,
                        _playingUrl == url ? Icons.pause_circle : Icons.play_arrow_rounded,
                      ),
                      onPressed: () => _playAudio(url),
                    ),
                    onTap: () {
                      // You can add more functionality here, like showing recording details
                      print('Tapped on recording ${index + 1}');
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}