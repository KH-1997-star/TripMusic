import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:trip_music_player/screens/home.dart';
import 'package:trip_music_player/screens/music_screen.dart';
import 'package:trip_music_player/services/random_number.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _MyAppBarState createState() => _MyAppBarState();
  @override
  Size get preferredSize => new Size.fromHeight(AppBar().preferredSize.height);
}

class _MyAppBarState extends State<MyAppBar> {
  int x = 0;

  bool dbClick = false;
  Timer timer;

  var rng = Random();
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(
        'Trip Music',
        style: TextStyle(
            fontFamily: 'Dancing', color: Colors.grey[200], fontSize: 40.0),
      ),
      actions: [
        dbClick == false
            ? TextButton.icon(
                onPressed: () {
                  timer = Timer.periodic(Duration(milliseconds: 800), (timer) {
                    setState(() {
                      x = RandomNumber().getNumber();
                      Home.x.value = x;
                      MyMusic.x.value = x;
                      dbClick = true;
                    });
                  });
                },
                icon: Icon(
                  Icons.sentiment_very_dissatisfied_outlined,
                  size: 35.0,
                  color: Colors.grey[200],
                ),
                label: Text(
                  'Tripi',
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Dancing',
                      color: Colors.grey[350]),
                ),
              )
            : TextButton.icon(
                onPressed: () {
                  timer.cancel();
                  setState(() => dbClick = false);
                },
                icon: Icon(
                  Icons.tag_faces_outlined,
                  size: 35.0,
                  color: Colors.grey[350],
                ),
                label: Text(
                  'Tripi off',
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey[350],
                      fontFamily: 'Dancing'),
                ),
              )
      ],
    );
  }
}
