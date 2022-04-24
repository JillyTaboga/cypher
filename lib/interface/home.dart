import 'package:cypher/controllers/cyphers_controller.dart';
import 'package:cypher/data/cyphers/letters_cyphers.dart';
import 'package:cypher/interface/cyphers/letter_cypher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final textController = StateProvider<String>(((ref) => ''));

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = ref.watch(textController);
    final textEditor = useTextEditingController(text: text);
    final translator = ref.watch(cypherProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            TextField(
              controller: textEditor,
              onChanged: (txt) {
                ref.read(textController.notifier).state = txt;
              },
              decoration: InputDecoration(
                label: const Text('Texto'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(text.characters.map((e) {
              return translator.translate(e);
            }).fold<String>(
                '', (previousValue, element) => previousValue += element)),
            const SizedBox(
              height: 10,
            ),
            const Expanded(child: CypherDiscs()),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ref.read(smallCypher.notifier).state =
                        LetterCypher.random();
                    ref.read(bigCypher.notifier).state = LetterCypher.random();
                  },
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: () {
                    ref.read(cypherProvider).copy();
                  },
                  child: const Text('Copy Cypher'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final clip = await Clipboard.getData('text');
                    final result = ref.read(cypherProvider).paste(
                          clip?.text ?? '',
                        );
                    ref.read(bigCypher.notifier).state = result.bigCypher;
                    ref.read(smallCypher.notifier).state = result.smallCypher;
                    ref.read(smallTurnProvider.notifier).state =
                        result.smallIndex;
                  },
                  child: const Text('Paste Cypher'),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
