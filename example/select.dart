import 'dart:io' show stdout;
import 'package:interact/interact.dart' show Select;

void main() {
  final languages = ['Rust', 'Dart', 'TypeScript'];
  final heroes = ['Iron Man', 'Captain America', 'My Dad'];

  final x = Select(
    prompt: "What's your favorite programming language?",
    options: languages,
  ).interact();

  stdout.writeln('Omg, I like ${languages[x]} too.');

  final _ = Select(
    prompt: "What about superheroes?",
    options: heroes,
    initialIndex: 2,
  ).interact();

  stdout.writeln('Agreed!');
}
