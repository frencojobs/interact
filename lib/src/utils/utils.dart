import 'dart:async' show StreamSubscription;
import 'dart:io' show ProcessSignal, exit;

import 'package:interact/src/framework/framework.dart' show Context;

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
