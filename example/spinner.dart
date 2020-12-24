import 'package:interact/interact.dart' show Spinner, Theme;

Future<void> main() async {
  final theme = Theme.basicTheme;

  final gift = Spinner.withTheme(
    theme: theme,
    icon: '🏆',
    rightPrompt: (done) => done
        ? 'here is a trophy for being patient'
        : 'searching a thing for you',
  ).interact();

  await Future.delayed(const Duration(seconds: 5));
  gift.done();
}
