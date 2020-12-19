// Package imports:
import 'package:dart_console/dart_console.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'framework/framework.dart';
import 'theme.dart';
import 'utils/prompt.dart';

class Confirm extends StatefulWidget<bool> {
  final String prompt;
  final bool defaultValue;
  final bool waitForNewLine;
  Theme theme = defaultTheme;

  Confirm({
    @required this.prompt,
    this.defaultValue = true,
    this.waitForNewLine = false,
  });

  Confirm.withTheme({
    @required this.prompt,
    @required this.theme,
    this.defaultValue = true,
    this.waitForNewLine = false,
  });

  @override
  _ConfirmState createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  bool answer = false;

  @override
  void initState() {
    super.initState();
    answer = widget.defaultValue;
    context.console.hideCursor();
  }

  @override
  void dispose() {
    super.dispose();

    context.console.cursorUp();
    context.console.eraseLine();
    context.console.cursorLeft();

    context.console.writeLine(promptSuccess(
      theme: widget.theme,
      message: widget.prompt,
      value: answer ? 'yes' : 'no',
    ));

    context.console.showCursor();
  }

  @override
  @protected
  void render(Context context) {
    if (context.renderCount > 0) {
      context.console.cursorUp();
      context.console.eraseLine();
      context.console.cursorLeft();
    }

    final line = StringBuffer();

    line.write(promptInput(
      theme: widget.theme,
      message: widget.prompt,
      hint: '(y/n)',
    ));
    line.write(
      ' ${widget.theme.promptTheme.defaultStyle(answer ? 'yes' : 'no')}',
    );
    context.console.writeLine(line.toString());
  }

  @override
  bool interact() {
    var key = context.console.readKey();

    while (!_shouldStop(key)) {
      switch (key.char) {
        case 'y':
        case 'Y':
          setState(() {
            answer = true;
          });
          break;
        case 'n':
        case 'N':
          setState(() {
            answer = false;
          });
          break;
        default:
          break;
      }
      key = context.console.readKey();
    }

    return answer;
  }

  bool _shouldStop(Key key) {
    return key.isControl &&
        (key.controlChar == ControlCharacter.ctrlC ||
            key.controlChar == ControlCharacter.enter);
  }
}
