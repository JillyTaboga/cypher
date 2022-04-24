import 'dart:convert';

import 'package:cypher/data/cyphers/letters_cyphers.dart';
import 'package:cypher/removediatrics.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final smallCypher =
    StateProvider<LetterCypher>(((ref) => LetterCypher.random()));

final bigCypher = StateProvider<LetterCypher>(((ref) => LetterCypher.random()));

final smallTurnProvider = StateProvider<int>((ref) => 0);

final cypherProvider = StateProvider((ref) {
  return CypherNotifier(
    bigCypher: ref.watch(bigCypher),
    smallCypher: ref.watch(smallCypher),
    smallIndex: ref.watch(smallTurnProvider),
  );
});

class CypherNotifier {
  final LetterCypher bigCypher;
  final LetterCypher smallCypher;

  final int smallIndex;
  CypherNotifier({
    required this.bigCypher,
    required this.smallCypher,
    required this.smallIndex,
  });

  copy() {
    final bigCyphe = bigCypher.cypher;
    final smallCyphe = smallCypher.cypher;
    final index = smallIndex;
    final code = jsonEncode({
      'big': bigCyphe,
      'bigColor': bigCypher.cypherColor.value,
      'small': smallCyphe,
      'smallColor': smallCypher.cypherColor.value,
      'index': index,
    });
    final base = base64Encode(const Utf8Encoder().convert(code));
    Clipboard.setData(ClipboardData(text: base));
  }

  CypherNotifier paste(String base) {
    final uncoded = base64Decode(base);
    final text = const Utf8Decoder().convert(uncoded);
    final map = jsonDecode(text);
    return CypherNotifier(
      bigCypher: LetterCypher.byCypher(
        (map['big'] as List<dynamic>).cast<int>(),
        (map['bigColor'] as int),
      ),
      smallCypher: LetterCypher.byCypher(
        (map['small'] as List<dynamic>).cast<int>(),
        (map['smallColor'] as int),
      ),
      smallIndex: map['index'] as int,
    );
  }

  String translate(String input) {
    final bigChar = bigCypher.characters.firstWhere(
      (element) => element == input.toLowerCase().removeDiatrics(),
      orElse: () => '%',
    );
    if (bigChar == '%') return '%';
    final int nomalSmallIndex =
        smallIndex <= 30 ? smallIndex : smallIndex - ((smallIndex ~/ 30) * 30);
    int bigIndex = bigCypher.characters.indexOf(bigChar) - (nomalSmallIndex);
    if (bigIndex < 0) bigIndex += 30;
    return smallCypher.characters[bigIndex];
  }
}
