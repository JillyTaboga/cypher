class LetterCypher {
  LetterCypher.random() : cypher = List<int>.generate(30, (i) => i);
  const LetterCypher.byCypher(this.cypher);

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
  ];

  List<String> get characters =>
      cypher.map((e) => _possibleCharacters[e]).toList();

  final List<int> cypher;
}
