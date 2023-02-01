import 'dart:io' show stdout;

import 'package:interact/interact.dart' show Select;

void main() {
  final languages = ['Rust', 'Dart', 'TypeScript'];
  final heroes = ['Iron Man', 'Captain America', 'My Dad'];

  final x = Select(
    prompt: 'Your favorite programming language',
    options: languages,
  ).interact();

  stdout.writeln('Omg, I like ${languages[x]} too.');

  final _ = Select(
    prompt: 'Favorite superhero',
    options: heroes,
    initialIndex: 2,
  ).interact();

  stdout.writeln('Agreed!');
}
