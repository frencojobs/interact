// Package imports:
import 'package:dart_console/dart_console.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'framework/framework.dart';
import 'theme.dart';

class Select<T> extends StatefulWidget<int> {
  final String name;
  final List<T> options;
  final SelectTheme theme = DefaultTheme.selectTheme;

  Select({
    @required this.name,
    @required this.options,
  }) : assert(options.isNotEmpty);

  @override
  _SelectState createState() => _SelectState();
}

class _SelectState extends State<Select> {
  int index = 0;

  @override
  void initState(Context context) {
    context.console.writeLine(widget.name);
    context.console.hideCursor();
  }

  @override
  void dispose(Context context) {
    context.console.showCursor();
  }

  @override
  void render(Context context) {
    if (context.renderCount > 0) {
      for (var i = 0; i < widget.options.length; i++) {
        context.console.cursorUp();
        context.console.eraseLine();
      }
      context.console.cursorLeft();
    }

    for (var i = 0; i < widget.options.length; i++) {
      final option = widget.options[i];
      final line =
          '${i == index ? widget.theme.activeItemPrefix : widget.theme.inactiveItemPrefix} $option';
      context.console.writeLine(line);
    }
  }

  @override
  int interact() {
    var key = context.console.readKey();

    while (!_shouldStop(key)) {
      switch (key.controlChar) {
        case ControlCharacter.arrowUp:
          setState(() {
            index = (index - 1) % widget.options.length;
          });
          break;
        case ControlCharacter.arrowDown:
          setState(() {
            index = (index + 1) % widget.options.length;
          });
          break;
        default:
          break;
      }
      key = context.console.readKey();
    }

    return index;
  }

  bool _shouldStop(Key key) {
    return key.isControl &&
        (key.controlChar == ControlCharacter.ctrlC ||
            key.controlChar == ControlCharacter.enter);
  }
}
