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

// Future<void> main() async {
//   final horse = Spinner(
//     icon: '🐴',
//     prompt: (done) => done ? 'finished' : 'waiting',
//   ).interact();

//   final rabbit = Spinner(
//     icon: '🐇',
//     prompt: (done) => done ? 'finished' : 'waiting',
//   ).interact();

//   // final turtle = Spinner(
//   //   icon: '🐢',
//   //   prompt: (done) => done ? 'finished' : 'waiting',
//   // ).interact();

//   await Future.delayed(const Duration(seconds: 1));
//   horse.done();

//   await Future.delayed(const Duration(seconds: 1));
//   rabbit.done();

//   // await Future.delayed(const Duration(milliseconds: 100));
//   // turtle.done();
// }
