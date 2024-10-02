import 'package:flutter/material.dart';
import 'dart:io';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          title: Text("I AM RICH"),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),

        ),
        body: Center(
          child: Image.asset('images/red_diamond.png'),
          ),
        ),
      ),
    );
}