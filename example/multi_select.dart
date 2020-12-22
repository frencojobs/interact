import 'dart:io' show stdout;
import 'package:clyde/clyde.dart' show MultiSelect;

void main() {
  final musicals = ['Hamilton', 'Dear Evan Hansen', 'Wicked'];

  final x = MultiSelect(
    prompt: "What's your favorite Musicals?",
    options: musicals,
    defaults: [false, true, false],
  ).interact();

  if (x.isEmpty) {
    stdout.writeln("Oh, you're not a musical fan.");
  } else if (x.length == 3) {
    stdout.writeln("Omg you're such a musical fan!");
  } else {
    stdout.writeln(
      '${x.map((i) => musicals[i]).join(' and ')} ${x.length == 1 ? 'is' : 'are'} the best!',
    );
  }
}
