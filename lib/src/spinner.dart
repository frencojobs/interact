import 'dart:async' show Timer, StreamSubscription;
import 'dart:io' show ProcessSignal;

import 'package:interact/src/framework/framework.dart';
import 'package:interact/src/theme/theme.dart';
import 'package:interact/src/utils/utils.dart';

String _prompt(bool x) => '';

/// A spinner or a loading indicator component.
class Spinner extends Component<SpinnerState> {
  /// Construts a [Spinner] component with the default theme.
  Spinner({
    required this.icon,
    this.leftPrompt = _prompt,
    this.rightPrompt = _prompt,
  }) : theme = Theme.defaultTheme;

  /// Constructs a [Spinner] component with the supplied theme.
  Spinner.withTheme({
    required this.icon,
    required this.theme,
    this.leftPrompt = _prompt,
    this.rightPrompt = _prompt,
  });

  Context? _context;

  /// The theme of the component.
  final Theme theme;

  /// The icon to be shown in place of the loading
  /// indicator after it's done.
  final String icon;

  /// The prompt function to be shown on the left side
  /// of the spinning indicator or icon.
  final String Function(bool) leftPrompt;

  /// The prompt function to be shown on the right side
  /// of the spinning indicator or icon.
  final String Function(bool) rightPrompt;

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
  SpinnerState({required this.done});

  /// Function to be called to indicate that the
  /// spinner is loaded.
  void Function() Function() done;
}

class _SpinnerState extends State<Spinner> {
  late bool done;
  late int index;
  late StreamSubscription<ProcessSignal> sigint;

  @override
  void init() {
    super.init();
    done = false;
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

    line.write(component.leftPrompt(done));

    if (done) {
      line.write(component.icon);
    } else {
      line.write(component.theme.spinners[index]);
    }
    line.write(' ');
    line.write(component.rightPrompt(done));

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
          done = true;
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
