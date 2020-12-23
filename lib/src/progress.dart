import 'package:meta/meta.dart';

import 'framework/framework.dart';
import 'theme/theme.dart';

class Progress extends Component<ProgressState> {
  final Theme theme;
  final int length;
  final String Function(int) prompt;

  Progress({
    @required this.length,
    @required this.prompt,
  }) : theme = Theme.defaultTheme;

  Progress.withTheme({
    @required this.theme,
    @required this.length,
    @required this.prompt,
  });

  @override
  _ProgressState createState() => _ProgressState();

  @override
  void disposeState(State state) {}
}

class ProgressState {
  int current;
  void Function(int) increase;
  void Function() done;

  ProgressState({
    @required this.current,
    @required this.increase,
    @required this.done,
  });
}

class _ProgressState extends State<Progress> {
  int current;
  bool done;

  @override
  void init() {
    super.init();
    current = 0;
    done = false;
    context.hideCursor();
  }

  @override
  void dispose() {
    context.showCursor();
    super.dispose();
  }

  @override
  void render() {
    final prompt = component.prompt(current);
    final line = StringBuffer();
    final occupied = component.theme.progressPrefix.length +
        component.theme.progressSuffix.length +
        prompt.length +
        1;
    final available = context.windowWidth - occupied;

    line.write(component.theme.progressPrefix);
    line.write(_progress(
      available,
      (available / component.length * current).round(),
      component.theme.emptyProgress,
      component.theme.filledProgress,
      component.theme.leadingProgress,
    ));
    line.write(component.theme.progressSuffix);
    line.write(' ');
    line.write(prompt);

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
      done: () {
        setState(() {
          done = true;
        });
        dispose();
      },
    );

    return state;
  }

  String _progress(
    int length,
    int filled,
    String empty,
    String filler,
    String leader,
  ) {
    return ''
        .padRight(filled - 1, filler)
        .padRight(filled, filled == length ? filler : leader)
        .padRight(length, empty);
  }
}
