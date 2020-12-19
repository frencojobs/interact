import 'dart:io' show stdout;
import 'package:clyde/clyde.dart' show Confirm;

void main() {
  final answer = Confirm(prompt: "Does it work?").interact();

  stdout.writeln(answer ? 'yes' : 'no');
}
