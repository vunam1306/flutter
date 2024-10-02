import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(
      XylophoneApp(),
    );

class XylophoneApp extends StatelessWidget {
  final player = AudioPlayer();

  void playSound(int soundNumber) async {
    await player.setSource(AssetSource('note$soundNumber.wav'));    
    player.resume();    
  }

  Expanded buildKey(Color color, int soundNumber) {
  return Expanded(
    child: MaterialButton(
      color: color,
      onPressed: () {
        playSound(soundNumber);
      },
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            //children stretch across the x-axis
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildKey(Colors.red, 1),
              buildKey(Colors.orange, 2),
              buildKey(Colors.yellow, 3),
              buildKey(Colors.green, 4),
              buildKey(Colors.teal, 5),
              buildKey(Colors.blue, 6),
              buildKey(Colors.purple, 7),
            ],
          ),
        ),
      ),
    );
  }
}