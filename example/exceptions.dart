import 'package:interact/interact.dart' show reset, Spinner;

Future<void> main() async {
  try {
    Spinner(
      icon: '🚨',
      rightPrompt: (done) => 'throwing an exception',
    ).interact();
    await Future.delayed(const Duration(seconds: 1));
    throw Exception();
  } catch (e) {
    reset(); // Reset everything to terminal defaults
    rethrow;
  }
}
