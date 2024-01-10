import 'package:interact/interact.dart'
    show MultiSpinner, Spinner, SpinnerStateType;

Future<void> main() async {
  final spinners = MultiSpinner();

  final horse = spinners.add(
    Spinner(
      icon: '🐴',
      rightPrompt: (state) => switch (state) {
        SpinnerStateType.inProgress => 'Processing...',
        SpinnerStateType.done => 'Done!',
        SpinnerStateType.failed => 'Failed!',
      },
    ),
  );

  final rabbit = spinners.add(
    Spinner(
      icon: '🐇',
      rightPrompt: (state) => switch (state) {
        SpinnerStateType.inProgress => 'Processing...',
        SpinnerStateType.done => 'Done!',
        SpinnerStateType.failed => 'Failed!',
      },
    ),
  );

  final turtle = spinners.add(
    Spinner(
      icon: '🐢',
      failedIcon: '✘',
      rightPrompt: (state) => switch (state) {
        SpinnerStateType.inProgress => 'Processing...',
        SpinnerStateType.done => 'Done!',
        SpinnerStateType.failed => 'Failed!',
      },
    ),
  );

  await Future.delayed(const Duration(seconds: 1));
  horse.done();

  await Future.delayed(const Duration(seconds: 1));
  rabbit.failed();

  await Future.delayed(const Duration(seconds: 2));
  turtle.done();
}
