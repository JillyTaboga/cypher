import 'dart:math';

import 'package:cypher/controllers/cyphers_controller.dart';
import 'package:cypher/data/cyphers/letters_cyphers.dart';
import 'package:cypher/interface/cyphers/letter_cypher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final textController = StateProvider<String>(((ref) => ''));

final textToDecript = StateProvider<String>(((ref) => ''));

final textDecripted = Provider<String>(((ref) {
  final text = ref.watch(textToDecript);
  final translator = ref.watch(cypherProvider);
  return text.characters
      .map((e) {
        return translator.decript(e);
      })
      .fold<String>('', (previousValue, element) => previousValue += element)
      .toUpperCase();
}));

final cript = Provider((ref) {
  final text = ref.watch(textController);
  final translator = ref.watch(cypherProvider);
  return text.characters
      .map((e) {
        return translator.translate(e);
      })
      .fold<String>('', (previousValue, element) => previousValue += element)
      .toUpperCase();
});

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = ref.watch(textController);
    final textDecript = ref.watch(textToDecript);
    final textDecriptedValue = ref.watch(textDecripted);
    final textToDecritpEditor = useTextEditingController(text: textDecript);
    final smallColor = ref.watch(smallCypher).cypherColor;
    final bigCollor = ref.watch(bigCypher).cypherColor;
    final textCript = ref.watch(cript);
    final mounted = useIsMounted();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, screen) {
          final small = screen.maxWidth < 500 || screen.maxHeight < 700;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (small) ...[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          TranslateWidget(
                            bigCollor: bigCollor,
                            text: text,
                            textCript: textCript,
                            smallColor: smallColor,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DecriptWidget(
                            textToDecritpEditor: textToDecritpEditor,
                            smallColor: smallColor,
                            text: text,
                            textDecriptedValue: textDecriptedValue,
                            bigCollor: bigCollor,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                if (!small) ...[
                  const SizedBox(
                    height: 30,
                  ),
                  TranslateWidget(
                    bigCollor: bigCollor,
                    text: text,
                    textCript: textCript,
                    smallColor: smallColor,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Expanded(
                    child: CypherDiscs(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DecriptWidget(
                    textToDecritpEditor: textToDecritpEditor,
                    smallColor: smallColor,
                    text: text,
                    textDecriptedValue: textDecriptedValue,
                    bigCollor: bigCollor,
                  ),
                ],
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
                        ref.read(bigCypher.notifier).state =
                            LetterCypher.random();
                        ref.read(textController.notifier).state = '';
                        ref.read(textToDecript.notifier).state = '';
                      },
                      child: const Text('Reiniciar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(cypherProvider).copy();
                      },
                      child: const Text('Copiar Cifra'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final clip = await Clipboard.getData('text');
                        try {
                          final result = ref.read(cypherProvider).paste(
                                clip?.text ?? '',
                              );
                          ref.read(bigCypher.notifier).state = result.bigCypher;
                          ref.read(smallCypher.notifier).state =
                              result.smallCypher;
                          ref.read(smallTurnProvider.notifier).state =
                              result.smallIndex;
                          textToDecritpEditor.text = '';
                        } catch (e) {
                          if (mounted()) {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Dado de cifra incorreto'),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Colar Cifra'),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Disco de cifra'),
                              content: const Text(
                                'O disco de cifra foi inventado na idade média, com a utilização de dois discos uma pessoa poderia trocar palavras ou letras por um simbolo em outro disco, dessa forma somente quem tinha os discos e a posição correta seria capaz de compreender a mensagem.\n\nPara testar o método basta copiar a cifra e enviar para uma amigo que a colará, garantindo que os dois estão usando os mesmos discos na mesma posição.',
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Ok'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.info),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                if (small) ...[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: screen.maxHeight - 100,
                                  width: screen.maxWidth - 20,
                                  child: const CypherDiscs(),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Fechar'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                        ),
                        child: const Text('Discos de Cifra'),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class DecriptWidget extends HookConsumerWidget {
  const DecriptWidget({
    Key? key,
    required this.textToDecritpEditor,
    required this.smallColor,
    required this.text,
    required this.textDecriptedValue,
    required this.bigCollor,
  }) : super(key: key);

  final TextEditingController textToDecritpEditor;
  final Color smallColor;
  final String text;
  final String textDecriptedValue;
  final Color bigCollor;

  @override
  Widget build(BuildContext context, ref) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: [
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height
            ].reduce((min)) /
            1.3,
      ),
      child: Column(
        children: [
          TextField(
            controller: textToDecritpEditor,
            onChanged: (txt) {
              ref.read(textToDecript.notifier).state = txt;
            },
            style: TextStyle(
              color: smallColor,
            ),
            decoration: InputDecoration(
              label: const Text('Texto para Descriptografar'),
              suffixIcon: IconButton(
                onPressed: () async {
                  final value = await Clipboard.getData('text');
                  if (value?.text != null) {
                    ref.read(textToDecript.notifier).state = value!.text!;
                    textToDecritpEditor.text = value.text!;
                  }
                },
                icon: Icon(
                  Icons.paste,
                  color: smallColor,
                ),
              ),
              labelStyle: TextStyle(
                color: smallColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: smallColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: smallColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(
                  color: smallColor,
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: textDecriptedValue.isEmpty
                    ? null
                    : () {
                        Clipboard.setData(
                            ClipboardData(text: textDecriptedValue));
                      },
                icon: Icon(
                  Icons.copy,
                  color: bigCollor,
                ),
              ),
              Text(
                'Descriptografado:',
                style: TextStyle(
                  fontSize: 16,
                  color: bigCollor,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            textDecriptedValue,
            style: TextStyle(
              fontSize: 20,
              color: bigCollor,
            ),
          ),
        ],
      ),
    );
  }
}

class TranslateWidget extends HookConsumerWidget {
  const TranslateWidget({
    Key? key,
    required this.bigCollor,
    required this.text,
    required this.textCript,
    required this.smallColor,
  }) : super(key: key);

  final Color bigCollor;
  final String text;
  final String textCript;
  final Color smallColor;

  @override
  Widget build(BuildContext context, ref) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: [
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height
            ].reduce((min)) /
            1.3,
      ),
      child: Column(
        children: [
          TextField(
            onChanged: (txt) {
              ref.read(textController.notifier).state = txt;
            },
            style: TextStyle(
              color: bigCollor,
            ),
            decoration: InputDecoration(
              label: const Text('Texto para Criptografar'),
              suffixIcon: IconButton(
                onPressed: text.isEmpty
                    ? null
                    : () {
                        Clipboard.setData(ClipboardData(text: text));
                      },
                icon: Icon(
                  Icons.copy,
                  color: bigCollor,
                ),
              ),
              labelStyle: TextStyle(
                color: bigCollor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: bigCollor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: bigCollor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(
                  color: bigCollor,
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: textCript.isEmpty
                    ? null
                    : () {
                        Clipboard.setData(ClipboardData(text: textCript));
                      },
                icon: Icon(
                  Icons.copy,
                  color: smallColor,
                ),
              ),
              Text(
                'Criptografado:',
                style: TextStyle(
                  fontSize: 16,
                  color: smallColor,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            textCript,
            style: TextStyle(
              fontSize: 20,
              color: smallColor,
            ),
          ),
        ],
      ),
    );
  }
}
