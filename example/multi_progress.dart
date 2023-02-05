import 'package:interact/interact.dart' show MultiProgress, Progress, Theme;
import 'package:tint/tint.dart';

Future<void> main() async {
  final bars = MultiProgress();

  const length = 1000;
  final theme = Theme.basicTheme.copyWith(
    emptyProgress: '-',
    progressPrefix: '',
    progressSuffix: '',
    emptyProgressStyle: (x) => x.blue(),
    filledProgressStyle: (x) => x.cyan(),
    leadingProgressStyle: (x) => x.cyan(),
  );

  final p1 = bars.add(
    Progress.withTheme(
      size: 0.5,
      theme: theme,
      length: length,
      leftPrompt: (current) =>
          '${(current / length).toStringAsPrecision(2).padLeft(4)} % ',
      rightPrompt: (current) => ' ${current.toString().padLeft(4)}/$length',
    ),
  );

  final p2 = bars.add(
    Progress.withTheme(
      size: 0.5,
      theme: theme,
      length: length,
      leftPrompt: (current) =>
          '${(current / length).toStringAsPrecision(2).padLeft(4)} % ',
      rightPrompt: (current) => ' ${current.toString().padLeft(4)}/$length',
    ),
  );

  final p3 = bars.add(
    Progress.withTheme(
      size: 0.5,
      theme: theme,
      length: length,
      leftPrompt: (current) =>
          '${(current / length).toStringAsPrecision(2).padLeft(4)} % ',
      rightPrompt: (current) => ' ${current.toString().padLeft(4)}/$length',
    ),
  );

  await Future.delayed(const Duration(seconds: 1));

  for (var i = 0; i < 500; i++) {
    await Future.delayed(const Duration(milliseconds: 2));
    p3.increase(1);
  }

  for (var i = 0; i < 500; i++) {
    await Future.delayed(const Duration(milliseconds: 1));
    p2.increase(1);
    p3.increase(1);
  }

  await Future.delayed(const Duration(seconds: 2));

  for (var i = 0; i < 500; i++) {
    await Future.delayed(const Duration(milliseconds: 2));
    p2.increase(1);
  }

  for (var i = 0; i < 500; i++) {
    await Future.delayed(const Duration(milliseconds: 3));
    p1.increase(2);
  }

  p1.done();
  p2.done();
  p3.done();
}
