import 'dart:io' show stdout;
import 'package:clyde/clyde.dart' show Select;

void main() {
  final options = ['Rust', 'Dart', 'TypeScript'];

  final choice = Select(
    prompt: "What's your favorite language?",
    options: options,
  ).interact();

  stdout.writeln(options[choice]);
}
