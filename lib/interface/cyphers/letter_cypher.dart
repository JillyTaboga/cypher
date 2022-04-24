import 'package:cypher/data/cyphers/letters_cyphers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LetterHookConsumer extends HookConsumerWidget {
  LetterHookConsumer({
    Key? key,
    List<int>? cyphers,
  })  : cypher = cyphers == null
            ? LetterCypher.random()
            : LetterCypher.byCypher(cyphers),
        super(key: key);

  final LetterCypher cypher;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        
      ),
    );
  }
}
