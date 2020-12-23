import 'dart:async' show Timer;

import 'package:meta/meta.dart';

import 'package:interact/interact.dart';
import 'framework/framework.dart';
import 'theme/theme.dart';

String _prompt(bool x) => '';

class Spinner extends Component<SpinnerState> {
  Context _context;
  final Theme theme;
  final String icon;
  final String Function(bool) leftPrompt;
  final String Function(bool) rightPrompt;

  Spinner({
    @required this.icon,
    this.leftPrompt = _prompt,
    this.rightPrompt = _prompt,
  }) : theme = Theme.defaultTheme;

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

class SpinnerState {
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
