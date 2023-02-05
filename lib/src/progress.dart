import 'dart:async' show StreamSubscription;
import 'dart:io' show ProcessSignal;

import 'package:interact/src/framework/framework.dart';
import 'package:interact/src/theme/theme.dart';
import 'package:interact/src/utils/utils.dart';
import 'package:tint/tint.dart';

String _prompt(int x) => '';

/// A progress bar component.
class Progress extends Component<ProgressState> {
  /// Constructs a [Progress] component with the default theme.
  Progress({
    required this.length,
    this.size = 1.0,
    this.leftPrompt = _prompt,
    this.rightPrompt = _prompt,
  }) : theme = Theme.defaultTheme;

  /// Constructs a [Progress] component with the supplied theme.
  Progress.withTheme({
    required this.theme,
    required this.length,
    this.size = 1.0,
    this.leftPrompt = _prompt,
    this.rightPrompt = _prompt,
  });

  Context? _context;

  /// The theme of the component.
  final Theme theme;

  /// The length of the progress bar.
  final int length;

  /// The size multiplier to be used when rendering
  /// the progress bar.
  ///
  /// Will be `1` by default.
  final double size;

  /// The prompt function to be shown on the left side
  /// of the progress bar.
  final String Function(int) leftPrompt;

  /// The prompt function to be shown on the right side
  /// of the progress bar.
  final String Function(int) rightPrompt;
  @override
  _ProgressState createState() => _ProgressState();

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
  /// to be used internally by [MultiProgress].
  // ignore: use_setters_to_change_properties
  void setContext(Context c) => _context = c;
}

/// Handles a progress bar's state.
class ProgressState {
  /// Constructs a [ProgressState] with it's all properties.
  ProgressState({
    required this.current,
    required this.clear,
    required this.increase,
    required this.done,
  });

  /// Current progress.
  int current;

  /// Clears the [current] by setting it to `0`.
  void Function() clear;

  /// Increases the [current] by the given value.
  void Function(int) increase;

  /// To be run to indicate that the progress is done,
  /// and the rendering can be wiped from the terminal.
  void Function() Function() done;
}

class _ProgressState extends State<Progress> {
  late int current;
  late bool done;
  late StreamSubscription<ProcessSignal> sigint;

  @override
  void init() {
    super.init();
    current = 0;
    done = false;
    sigint = handleSigint();
    context.hideCursor();
  }

  @override
  void dispose() {
    context.wipe();
    context.showCursor();
    super.dispose();
  }

  @override
  void render() {
    final line = StringBuffer();
    final leftPrompt = component.leftPrompt(current);
    final rightPrompt = component.rightPrompt(current);
    final occupied = component.theme.progressPrefix.strip().length +
        component.theme.progressSuffix.strip().length +
        leftPrompt.strip().length +
        rightPrompt.strip().length;
    final available = (context.windowWidth * component.size).round() - occupied;

    line.write(leftPrompt);
    line.write(component.theme.progressPrefix);
    line.write(
      _progress(
        component.theme,
        available,
        (available / component.length * current).round(),
      ),
    );
    line.write(component.theme.progressSuffix);
    line.write(rightPrompt);

    context.writeln(line.toString());
  }

  @override
  ProgressState interact() {
    final state = ProgressState(
      current: current,
      increase: (int n) {
        if (current < component.length) {
          setState(() {
            current += n;
          });
        }
      },
      clear: () {
        setState(() {
          current = 0;
        });
      },
      done: () {
        setState(() {
          done = true;
          sigint.cancel();
        });

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

  String _progress(
    Theme theme,
    int length,
    int filled,
  ) {
    final f = theme
        .filledProgressStyle(''.padRight(filled - 1, theme.filledProgress));
    final l = filled == 0
        ? ''
        : filled == length
            ? theme.filledProgressStyle(theme.filledProgress)
            : theme.leadingProgressStyle(theme.leadingProgress);
    final e = theme
        .emptyProgressStyle(''.padRight(length - filled, theme.emptyProgress));

    return '$f$l$e';
  }
}
