import 'package:interact/interact.dart' show MultiProgress, Progress, Theme;

Future<void> main() async {
  final bars = MultiProgress();

  const length = 1000;
  final theme = Theme.basicTheme;

  final p1 = bars.add(Progress.withTheme(
    size: 0.5,
    theme: theme,
    length: length,
    rightPrompt: (current) => ' ${current.toString().padLeft(4)}/$length',
  ));

  final p2 = bars.add(Progress.withTheme(
    size: 0.5,
    theme: theme,
    length: length,
    rightPrompt: (current) => ' ${current.toString().padLeft(4)}/$length',
  ));

  for (var i = 0; i < 500; i++) {
    await Future.delayed(const Duration(milliseconds: 5));
    p1.increase(2);
    p2.increase(1);
  }

  await Future.delayed(const Duration(seconds: 2));
  p2.increase(500);

  await Future.delayed(const Duration(milliseconds: 5));
  p1.done();
  p2.done();
}
