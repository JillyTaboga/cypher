import 'dart:math';

import 'package:flutter/material.dart';

List<int> get _randomCypher {
  List<int> cyphers = [];
  for (var n = Random().nextInt(30);
      cyphers.length < 30;
      n = Random().nextInt(30)) {
    while (cyphers.contains(n)) {
      n = Random().nextInt(30);
    }
    cyphers.add(n);
  }
  return cyphers;
}

Color get _randomColor {
  return Color.fromRGBO(
      Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), 1);
}

class LetterCypher {
  LetterCypher.random()
      : cypher = _randomCypher,
        cypherColor = _randomColor;
  LetterCypher.byCypher(this.cypher, int color) : cypherColor = Color(color);

  Color cypherColor;

  static const List<String> _possibleCharacters = [
    "a",
    "b",
    "c",
    "d",
    "e",
    "f",
    "g",
    "h",
    "i",
    "j",
    "k",
    "l",
    "m",
    "n",
    "o",
    "p",
    "q",
    "r",
    "s",
    "t",
    "u",
    "v",
    "w",
    "x",
    "y",
    "z",
    "-",
    " ",
    ",",
    ".",
  ];

  List<String> get characters =>
      cypher.map((e) => _possibleCharacters[e]).toList();

  final List<int> cypher;
}
