import 'dart:async' show Timer, StreamSubscription;
import 'dart:io' show ProcessSignal;

import 'package:interact/src/framework/framework.dart';
import 'package:interact/src/theme/theme.dart';
import 'package:interact/src/utils/utils.dart';

String _prompt(SpinnerStateType _) => '';

enum SpinnerStateType { inProgress, done, failed }

/// A spinner or a loading indicator component.
class Spinner extends Component<SpinnerState> {
  /// Construts a [Spinner] component with the default theme.
  Spinner({
    required this.icon,
    String? failedIcon,
    this.leftPrompt = _prompt,
    this.rightPrompt = _prompt,
  })  : theme = Theme.defaultTheme,
        failedIcon = failedIcon ?? Theme.defaultTheme.errorPrefix;

  /// Constructs a [Spinner] component with the supplied theme.
  Spinner.withTheme({
    required this.icon,
    String? failedIcon,
    required this.theme,
    this.leftPrompt = _prompt,
    this.rightPrompt = _prompt,
  }) : failedIcon = failedIcon ?? Theme.defaultTheme.errorPrefix;

  Context? _context;

  /// The theme of the component.
  final Theme theme;

  /// The icon to be shown in place of the loading
  /// indicator after it's done.
  final String icon;

  /// The icon to be shown in place of the loading
  /// indicator after it's failed.
  final String failedIcon;

  /// The prompt function to be shown on the left side
  /// of the spinning indicator or icon.
  final String Function(SpinnerStateType) leftPrompt;

  /// The prompt function to be shown on the right side
  /// of the spinning indicator or icon.
  final String Function(SpinnerStateType) rightPrompt;

  @override
  _SpinnerState createState() => _SpinnerState();

  @override
  void disposeState(State state) {}

  @override
  State pipeState(State state) {
    if (_context != null) {
      state.setContext(_context!);
    }
    return state;
  }

  /// Sets the context to a new one,
  /// to be used internally by [MultiSpinner].
  // ignore: use_setters_to_change_properties
  void setContext(Context c) => _context = c;
}

/// Handles a [Spinner]'s state.
class SpinnerState {
  /// Constructs a state to manage a [Spinner].
  SpinnerState({required this.done, required this.failed});

  /// Function to be called to indicate that the
  /// spinner is loaded.
  void Function() Function() done;

  /// Function to be called to indicate that the
  /// spinner is failed.
  void Function() Function() failed;
}

class _SpinnerState extends State<Spinner> {
  late SpinnerStateType stateType;
  late int index;
  late StreamSubscription<ProcessSignal> sigint;

  @override
  void init() {
    super.init();
    stateType = SpinnerStateType.inProgress;
    index = 0;
    sigint = handleSigint();
    context.hideCursor();
  }

  @override
  void dispose() {
    context.showCursor();
    super.dispose();
  }

  @override
  void render() {
    final line = StringBuffer();

    line.write(component.leftPrompt(stateType));

    if (stateType == SpinnerStateType.done) {
      line.write(component.icon);
    } else if (stateType == SpinnerStateType.failed) {
      line.write(component.failedIcon);
    } else {
      line.write(component.theme.spinners[index]);
    }
    line.write(' ');
    line.write(component.rightPrompt(stateType));

    context.writeln(line.toString());
  }

  @override
  SpinnerState interact() {
    final timer = Timer.periodic(
      Duration(
        milliseconds: component.theme.spinningInterval,
      ),
      (timer) {
        setState(() {
          index = (index + 1) % component.theme.spinners.length;
        });
      },
    );

    final state = SpinnerState(
      done: () {
        setState(() {
          stateType = SpinnerStateType.done;
          sigint.cancel();
        });
        timer.cancel();
        if (component._context != null) {
          return dispose;
        } else {
          dispose();
          return () {};
        }
      },
      failed: () {
        setState(() {
          stateType = SpinnerStateType.failed;
          sigint.cancel();
        });
        timer.cancel();
        if (component._context != null) {
          return dispose;
        } else {
          dispose();
          return () {};
        }
      },
    );

    return state;
  }
}
