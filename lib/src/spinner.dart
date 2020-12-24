import 'dart:async' show Timer;

import 'package:meta/meta.dart';

import 'package:interact/interact.dart';
import 'framework/framework.dart';
import 'theme/theme.dart';

String _prompt(bool x) => '';

/// A spinner or a loading indicator component.
class Spinner extends Component<SpinnerState> {
  Context _context;

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

  /// Construts a [Spinner] component with the default theme.
  Spinner({
    @required this.icon,
    this.leftPrompt = _prompt,
    this.rightPrompt = _prompt,
  }) : theme = Theme.defaultTheme;

  /// Constructs a [Spinner] component with the supplied theme.
  Spinner.withTheme({
    @required this.icon,
    @required this.theme,
    this.leftPrompt = _prompt,
    this.rightPrompt = _prompt,
  });

  @override
  _SpinnerState createState() => _SpinnerState();

  @override
  void disposeState(State state) {}

  @override
  State pipeState(State state) {
    if (_context != null) {
      state.setContext(_context);
    }
    return state;
  }

  void setContext(Context c) => _context = c;
}

/// Handles a [Spinner]'s state.
class SpinnerState {
  /// Function to be called to indicate that the
  /// spinner is loaded.
  void Function() Function() done;

  SpinnerState({@required this.done});
}

class _SpinnerState extends State<Spinner> {
  bool done;
  int index;

  @override
  void init() {
    super.init();
    done = false;
    index = 0;
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
      line.write(component.theme.spinner[index]);
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
          index = (index + 1) % component.theme.spinner.length;
        });
      },
    );

    final state = SpinnerState(
      done: () {
        setState(() {
          done = true;
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
