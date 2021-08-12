import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:trip_music_player/consts/consts.dart';
import 'package:trip_music_player/screens/music_screen.dart';

import 'package:trip_music_player/widgets/my_app_bar.dart';

class Home extends StatefulWidget {
  static ValueNotifier<int> x = ValueNotifier(0);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  List<SongInfo> songs = [];

  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  int currentIndex = 0;

  getSongs() async {
    if (await Permission.storage.request().isGranted) {
      songs = await audioQuery.getSongs();
      setState(() {
        songs = songs;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(),
        body: ValueListenableBuilder(
            valueListenable: Home.x,
            builder: (BuildContext context, int newx, Widget child) {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [myHighColors[newx], myLowColors[newx]])),
                  child: Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: ListView.separated(
                          itemBuilder: (context, index) => ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage: songs[index].albumArtwork ==
                                          null
                                      ? AssetImage('assets/images/itunes.png')
                                      : FileImage(
                                          File(songs[index].albumArtwork)),
                                ),
                                title: Text(songs[index].title),
                                subtitle: Text(songs[index].artist),
                                onTap: () {
                                  currentIndex = index;

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => MyMusic(
                                            index: currentIndex,
                                            mySongs: songs,
                                          )));
                                },
                              ),
                          separatorBuilder: (context, index) => Divider(),
                          itemCount: songs.length)));
            }));
  }
}
