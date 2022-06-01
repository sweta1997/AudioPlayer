import 'dart:io';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/music_player.dart';

class Tracks extends StatefulWidget {
  const Tracks({Key? key}) : super(key: key);

  @override
  _TracksState createState() => _TracksState();
}

class _TracksState extends State<Tracks> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<SongInfo> songs = [];
  int currentIndex = 0;
  final GlobalKey<MusicPlayerState> key = GlobalKey<MusicPlayerState>();

  @override
  void initState() {
    super.initState();
    getTracks();
  }

  void getTracks() async {
    songs = await audioQuery.getSongs();
    setState(() {
      songs = songs;
    });
  }

  void changeTrack(bool isNext) {
    if (isNext) {
      if (currentIndex != songs.length - 1) {
        currentIndex++;
      }
    } else {
      if (currentIndex != 0) {
        currentIndex--;
      }
    }
    key.currentState?.setSong(songs[currentIndex]);
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        leading: const Icon(Icons.music_note, color: Colors.black),
        title: const Text("SOUL", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        itemCount: songs.length,
        itemBuilder: (context, index) => ListTile(
          leading: CircleAvatar(
            backgroundImage: songs[index].albumArtwork == null
                ? const AssetImage('assets/images/music_gradient.jpg')
                : FileImage(File(songs[index].albumArtwork)) as ImageProvider,
          ),
          title: Text(songs[index].title),
          subtitle: Text(songs[index].artist),
          onTap: () {
            currentIndex = index;
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MusicPlayer(
                    changeTrack: changeTrack,
                    songInfo: songs[currentIndex],
                    key: key)));
          },
        ),
      ),
    );
  }
}
