import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:trip_music_player/consts/consts.dart';

// ignore: must_be_immutable
class MyMusic extends StatefulWidget {
  static ValueNotifier<int> x = ValueNotifier(0);
  int index = 0;
  List<SongInfo> mySongs = [];

  MyMusic({this.index, this.mySongs});

  @override
  MyMusicState createState() => MyMusicState();
}

class MyMusicState extends State<MyMusic> {
  AudioPlayer audioPlayer = AudioPlayer();

  bool playing = true, init = false, done = false, completed = false;

  getDuration() async {
    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        _duration = d;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((Duration p) {
      setState(() {
        _position = p;
      });
    });
  }

  nextMusic() {
    if (widget.index < widget.mySongs.length - 1) {
      setState(() {
        widget.index += 1;
      });
      getDuration();
      playMusic();

      init = true;
      Timer(Duration(seconds: 2), () => init = false);
    }
  }

  previousMusic() {
    if (widget.index > 0) {
      setState(() {
        widget.index -= 1;
      });
      getDuration();
      playMusic();
      init = true;
      Timer(Duration(seconds: 2), () => init = false);
    }
  }

  Duration _duration = new Duration(), _position = new Duration();

  playMusic() async {
    await audioPlayer.play(widget.mySongs[widget.index].filePath,
        isLocal: true);
  }

  pauseMusic() {
    audioPlayer.pause();
  }

  stopMusic() {
    audioPlayer.stop();
  }

  void seekToSecond(int mysecond) {
    Duration newDuration = Duration(seconds: mysecond);

    audioPlayer.seek(newDuration);
  }

  void initState() {
    super.initState();
    getDuration();
    playMusic();

    init = true;
    Timer(Duration(seconds: 2), () => init = false);
  }

  @override
  Widget build(BuildContext context) {
    double max = _duration.inSeconds.toDouble() + 1,
        currentVal = _position.inSeconds.toDouble();
    audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == AudioPlayerState.COMPLETED) {
        setState(() {
          completed = true;
        });
      }
    });

    if (completed == true) {
      nextMusic();
      setState(() {
        completed = false;
      });
      print(max);
      print(currentVal);
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          stopMusic();

          Navigator.pop(context);
        }),
        elevation: 0,
        title: Text(
          'Trip Music',
          style: TextStyle(
              fontFamily: 'Dancing', color: Colors.grey[200], fontSize: 40.0),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: MyMusic.x,
        builder: (BuildContext context, int newX, Widget child) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [myHighColors[newX], myLowColors[newX]])),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 0),
              child: Column(
                children: [
                  SizedBox(
                    height: (MediaQuery.of(context).size.height) / 9,
                  ),
                  CircleAvatar(
                    radius: 100,
                    backgroundImage: widget
                                .mySongs[widget.index].albumArtwork ==
                            null
                        ? AssetImage('assets/images/itunes.png')
                        : FileImage(
                            File(widget.mySongs[widget.index].albumArtwork)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      widget.mySongs[widget.index].title,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      widget.mySongs[widget.index].artist,
                      style: TextStyle(
                          color: Colors.grey[100],
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Row(
                    children: [
                      (currentVal == 0.0)
                          ? Text('00:00')
                          : Text(_position
                              .toString()
                              .split('.')
                              .first
                              .substring(2)),
                      Slider(
                        inactiveColor: Colors.black,
                        activeColor: Colors.red,
                        value: currentVal,
                        min: 0.0,
                        max: max,
                        onChanged: (double value) {
                          seekToSecond(value.toInt());
                        },
                      ),
                      Text(_duration.toString().split('.').first.substring(2))
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          child: Icon(
                            Icons.skip_previous,
                            size: 50.0,
                            color: Colors.blue,
                          ),
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            previousMusic();
                          }),
                      SizedBox(
                        width: 15.0,
                      ),
                      if (playing == true)
                        TextButton.icon(
                            onPressed: () {
                              pauseMusic();
                              setState(() {
                                playing = false;
                              });
                            },
                            icon: Icon(
                              Icons.pause,
                              size: 50.0,
                            ),
                            label: Text(''))
                      else if (playing == false ||
                          (currentVal == max) ||
                          currentVal == max + 1)
                        TextButton.icon(
                            onPressed: () {
                              playMusic();
                              setState(() {
                                playing = true;
                              });
                            },
                            icon: Icon(
                              Icons.play_arrow,
                              size: 50.0,
                            ),
                            label: Text('')),
                      SizedBox(
                        width: 15.0,
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.skip_next,
                          size: 50.0,
                          color: Colors.blue,
                        ),
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          nextMusic();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
