import 'dart:async' show StreamSubscription;
import 'dart:io' show ProcessSignal, exit, stdout;
import '../framework/framework.dart' show Context;

/// Catch sigint and reset to terminal defaults before exit.
StreamSubscription<ProcessSignal> handleSigint() {
  int sigints = 0;
  return ProcessSignal.sigint.watch().listen((event) async {
    if (++sigints >= 1) {
      Context.reset();
      exit(1);
    }
  });
}

int getColumns(int maxOptionLength, int length) {
  final columnWidth = maxOptionLength + 6;
  final int columns;
  if (length < (stdout.terminalColumns ~/ columnWidth)) {
    columns = length;
  } else {
    columns = stdout.terminalColumns ~/ columnWidth;
  }
  return columns;
}
