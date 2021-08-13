import 'package:flutter/material.dart';

import 'package:trip_music_player/screens/home.dart';
import 'package:trip_music_player/screens/load_screen.dart';
import 'package:trip_music_player/screens/music_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: Colors.black45),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoadScreen(),
        '/home': (context) => Home(),
        '/music_on': (context) => MyMusic()
      },
    );
  }
}
