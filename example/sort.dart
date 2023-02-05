import 'dart:io' show stdout;

import 'package:interact/interact.dart' show Sort;

void main() {
  final models = ['S', '3', 'X', 'Y'].map((x) => 'Model $x').toList();

  final sorted = Sort(
    prompt: 'Sort Tesla models from favorite to least',
    options: models,
  ).interact();

  stdout.writeln("${sorted[0]} is everyone's favorite!");
  stdout.writeln('My least favorite is also ${sorted[3]}.');
}
