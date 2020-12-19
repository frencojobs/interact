// Package imports:
import 'package:dart_console/dart_console.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'framework/framework.dart';
import 'theme.dart';
import 'utils/prompt.dart';

class Select extends StatefulWidget<int> {
  final String prompt;
  final List<String> options;
  Theme theme = defaultTheme;

  Select({
    @required this.prompt,
    @required this.options,
  });

  Select.withTheme({
    @required this.prompt,
    @required this.options,
    @required this.theme,
  });

  @override
  _SelectState createState() => _SelectState();
}

class _SelectState extends State<Select> {
  int index = 0;

  @override
  void initState() {
    super.initState();

    if (widget.options.isEmpty) {
      throw Exception("Options can't be empty");
    }

    context.console.writeLine(promptInput(
      theme: widget.theme,
      message: widget.prompt,
    ));

    context.console.hideCursor();
  }

  @override
  void dispose() {
    super.dispose();

    for (var i = 0; i < widget.options.length + 1; i++) {
      context.console.cursorUp();
      context.console.eraseLine();
    }
    context.console.cursorLeft();

    context.console.writeLine(promptSuccess(
      theme: widget.theme,
      message: widget.prompt,
      value: widget.options[index],
    ));

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
      final line = StringBuffer();

      if (i == index) {
        line.write(widget.theme.selectTheme.activeItemPrefix);
      } else {
        line.write(widget.theme.selectTheme.inactiveItemPrefix);
      }
      line.write(' $option');
      context.console.writeLine(line.toString());
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
