import 'dart:io' show stdout;
import 'package:clyde/clyde.dart' show Input, ValidationError;

void main() {
  final name = Input(prompt: "What's your name?").interact();
  stdout.writeln(name);

  final email = Input(
    prompt: "What's your email?",
    validator: (String x) {
      if (x.contains('@')) {
        return true;
      } else {
        throw ValidationError('Not a valid email');
      }
    },
  ).interact();
  stdout.writeln(email);

  final planet = Input(
    prompt: "What's your planet?",
    defaultValue: 'Earth',
  ).interact();
  stdout.writeln(planet);

  final galaxy = Input(
    prompt: "In what galaxy do you live?",
    initialText: 'Andromeda',
  ).interact();
  stdout.writeln(galaxy);
}
