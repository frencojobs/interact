import 'package:interact/interact.dart' show Spinner, SpinnerStateType, Theme;

Future<void> main() async {
  final theme = Theme.basicTheme;

  final gift = Spinner.withTheme(
    theme: theme,
    icon: '🏆',
    rightPrompt: (state) => switch (state) {
      SpinnerStateType.inProgress => 'Processing...',
      SpinnerStateType.done => 'Done!',
      SpinnerStateType.failed => 'Failed!',
    },
  ).interact();

  await Future.delayed(const Duration(seconds: 5));
  gift.done();
}
