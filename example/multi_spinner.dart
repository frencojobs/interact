import 'package:interact/interact.dart' show MultiSpinner, Spinner;

Future<void> main() async {
  final spinners = MultiSpinner();

  final horse = spinners.add(
    Spinner(
      icon: '🐴',
      rightPrompt: (done) => done ? 'finished' : 'waiting',
    ),
  );

  final rabbit = spinners.add(
    Spinner(
      icon: '🐇',
      rightPrompt: (done) => done ? 'finished' : 'waiting',
    ),
  );

  final turtle = spinners.add(
    Spinner(
      icon: '🐢',
      rightPrompt: (done) => done ? 'finished' : 'waiting',
    ),
  );

  await Future.delayed(const Duration(seconds: 1));
  horse.done();

  await Future.delayed(const Duration(seconds: 1));
  rabbit.done();

  await Future.delayed(const Duration(seconds: 2));
  turtle.done();
}
