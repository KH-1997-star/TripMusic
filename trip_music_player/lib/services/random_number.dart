import 'dart:math';

import 'package:trip_music_player/consts/consts.dart';

class RandomNumber {
  var rng = Random();
  int x = 0;

  int getNumber() {
    x = rng.nextInt(myHighColors.length);
    return x;
  }
}
