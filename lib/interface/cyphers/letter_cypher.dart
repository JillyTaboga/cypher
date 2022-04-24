import 'dart:math';

import 'package:cypher/controllers/cyphers_controller.dart';
import 'package:cypher/data/cyphers/letters_cyphers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CypherDiscs extends HookConsumerWidget {
  const CypherDiscs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final smallTurn = 1 / 30 * ref.watch(smallTurnProvider);
    final staticCypher = ref.watch(bigCypher);
    final rotateCypher = ref.watch(smallCypher);
    return SizedBox(
      height: double.maxFinite,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CypherDisc(cypher: staticCypher),
          GestureDetector(
            onTap: () {
              ref.read(smallTurnProvider.notifier).state++;
            },
            child: AnimatedRotation(
              turns: smallTurn,
              duration: const Duration(milliseconds: 500),
              child: FractionallySizedBox(
                widthFactor: 0.8,
                heightFactor: 0.8,
                child: CypherDisc(cypher: rotateCypher),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CypherDisc extends StatelessWidget {
  const CypherDisc({
    Key? key,
    required this.cypher,
  }) : super(key: key);

  final LetterCypher cypher;

  @override
  Widget build(BuildContext context) {
    final luminosity = cypher.cypherColor.computeLuminance() < 0.1;
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: CustomPaint(
              painter: DiscPainter(
                color: cypher.cypherColor,
              ),
            ),
          ),
          for (final letter in cypher.characters)
            LetterWidget(
              letter: letter,
              index: cypher.characters.indexOf(letter),
              size: constraints.biggest,
              dark: luminosity,
            )
        ],
      );
    });
  }
}

class LetterWidget extends StatelessWidget {
  const LetterWidget({
    Key? key,
    required this.letter,
    required this.index,
    required this.size,
    required this.dark,
  }) : super(key: key);

  final String letter;
  final int index;
  final Size size;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final radius = ([size.height, size.width].reduce(min) / 2) - 16;
    final width = radius / 6;
    final height = radius / 5;

    final centerY = (size.height / 2) - (height / 2);
    final centerX = (size.width / 2) - (width / 2);

    final radian1 = 360 / 30 * index * pi / 180;
    final radian2 = 360 / 30 * (index + 1) * pi / 180;
    final radian = (radian1 + radian2) / 2;

    final xPoint = radius * cos(radian) + centerX;
    final yPoint = radius * sin(radian) + centerY;

    return Positioned(
      top: yPoint,
      left: xPoint,
      width: width,
      height: height,
      child: Transform.rotate(
        angle: radian,
        child: Container(
          width: width,
          height: height,
          alignment: Alignment.centerLeft,
          child: Text(
            letter.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: dark ? Colors.white54 : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}

class DiscPainter extends CustomPainter {
  Color color;
  DiscPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = (size.height / 2);
    final centerX = (size.width / 2);
    final center = Offset(centerX, centerY);
    final radius = [size.height, size.width].reduce(min) / 2;

    final circlePaint = Paint()..color = color;
    final shadow = Paint()..color = Colors.black.withOpacity(0.2);
    final lines = Paint()
      ..color = color.computeLuminance() < 0.1
          ? Colors.white.withOpacity(0.2)
          : Colors.black.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawCircle(center, radius, shadow);
    canvas.drawCircle(center, radius - 2, circlePaint);
    final linesPositions =
        List.generate(30, (index) => 360 / 30 * index * pi / 180);
    for (final e in linesPositions) {
      final xPoint = (radius - 2) * cos(e) + centerX;
      final yPoint = (radius - 2) * sin(e) + centerY;
      canvas.drawLine(center, Offset(xPoint, yPoint), lines);
    }
    canvas.drawCircle(center, radius / 1.3, circlePaint);
    canvas.drawCircle(center, radius / 1.3, lines);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
