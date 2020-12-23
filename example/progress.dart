import 'package:interact/interact.dart' show Progress, Theme;

Future<void> main() async {
  const length = 1000;
  final theme = Theme.colorfulTheme;

  final progress = Progress.withTheme(
    theme: theme,
    length: length,
    rightPrompt: (current) => ' ${current.toString().padLeft(3)}/$length',
  ).interact();

  for (var i = 0; i < 500; i++) {
    await Future.delayed(const Duration(milliseconds: 5));
    progress.increase(2);
  }

  progress.done();
}
