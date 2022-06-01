// ignore_for_file: import_of_legacy_library_into_null_safe, must_be_immutable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayer extends StatefulWidget {
  SongInfo songInfo;
  Function changeTrack;
  final GlobalKey<MusicPlayerState> key;
  MusicPlayer(
      {required this.songInfo, required this.changeTrack, required this.key})
      : super(key: key);
  MusicPlayerState createState() => MusicPlayerState();
}

class MusicPlayerState extends State<MusicPlayer> {
  double minimumValue = 0.0, maximumValue = 0.0, currentValue = 0.0;
  String currentTime = '', endTime = '';
  bool isPlaying = true;
  final AudioPlayer player = AudioPlayer();

  void initState() {
    super.initState();
    setSong(widget.songInfo);
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  void setSong(SongInfo songInfo) async {
    widget.songInfo = songInfo;
    await player.setUrl(widget.songInfo.uri);
    currentValue = minimumValue;
    maximumValue = player.duration!.inMilliseconds.toDouble();
    print(maximumValue);
    setState(() {
      currentTime = getDuration(currentValue);
      endTime = getDuration(maximumValue);
    });
    isPlaying = false;
    changeStatus();
    player.positionStream.listen((duration) {
      currentValue = duration.inMilliseconds.toDouble();
      setState(() {
        currentTime = getDuration(currentValue);
      });
    });
  }

  void changeStatus() {
    setState(() {
      isPlaying = !isPlaying;
    });
    if (isPlaying) {
      player.play();
    } else {
      player.pause();
    }
  }

  String getDuration(double value) {
    Duration duration = Duration(milliseconds: value.round());
    return [duration.inMinutes, duration.inSeconds]
        .map((element) => element.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:const  Color.fromARGB(255, 170, 82, 185),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_sharp, color: Colors.black)),
        title: const Text("Now Playing", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(5, 40, 5, 0),
        child: Column(children: <Widget>[
          CircleAvatar(
            backgroundImage: widget.songInfo.albumArtwork == null
                ? const AssetImage('assets/images/music_gradient.jpg')
                : FileImage(File(widget.songInfo.albumArtwork))
                    as ImageProvider,
            radius: 95,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 7),
            child: Text(
              widget.songInfo.displayName,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
            child: Text(
              widget.songInfo.artist,
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Slider(
            inactiveColor: Colors.grey,
            activeColor: const Color.fromARGB(255, 170, 82, 185),
            min: minimumValue,
            max: maximumValue,
            value: currentValue > maximumValue
                ? (() {
                    changeStatus();
                    return maximumValue;
                  }())
                : currentValue,
            onChanged: (value) {
              currentValue = value;
              player.seek(Duration(milliseconds: currentValue.round()));
            },
          ),
          Container(
            transform: Matrix4.translationValues(0, -7, 0),
            margin: const EdgeInsets.fromLTRB(5, 0, 5, 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(currentTime,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500)),
                Text(endTime,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500))
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  child: const Icon(Icons.skip_previous,
                      color: Colors.white, size: 55),
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    widget.changeTrack(false);
                  },
                ),
                GestureDetector(
                  child: Icon(
                      isPlaying
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_fill_rounded,
                      color:Colors.white,
                      size: 75),
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    changeStatus();
                  },
                ),
                GestureDetector(
                  child: const Icon(Icons.skip_next,
                      color: Colors.white, size: 55),
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    widget.changeTrack(true);
                  },
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
