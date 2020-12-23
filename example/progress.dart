import 'package:interact/interact.dart' show Progress, Theme;

Future<void> main() async {
  const length = 100;

  final progress = Progress.withTheme(
    theme: Theme.basicTheme,
    length: length,
    prompt: (current) => '${current.toString().padLeft(3)}/$length',
  ).interact();

  for (var i = 0; i < 100; i++) {
    await Future.delayed(const Duration(milliseconds: 5));
    progress.increase(1);
  }

  progress.done();
}
