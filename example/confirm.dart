import 'dart:io' show stdout;

import 'package:interact/interact.dart' show Confirm;

void main() {
  final x = Confirm(prompt: 'Does it work?').interact();
  stdout.writeln(x ? 'Awesome!' : 'Wait what! Check again.');

  final y = Confirm(
    prompt: 'Is there a default value?',
    defaultValue: true,
  ).interact();
  stdout.writeln(y ? 'Wonderful!' : 'Really! This is sad.');

  final z = Confirm(
    prompt: 'Do you have to hit enter?',
    waitForNewLine: true,
  ).interact();
  stdout.writeln(z ? 'Magnificent!' : 'Ugh, Why!');
}
