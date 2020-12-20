// Package imports:
import 'package:dart_console/dart_console.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'framework/framework.dart';
import 'theme/theme.dart';
import 'utils/prompt.dart';

class Confirm extends StatefulWidget<bool> {
  final String prompt;
  final bool defaultValue;
  final bool waitForNewLine;
  Theme theme = Theme.defaultTheme;

  Confirm({
    @required this.prompt,
    this.defaultValue,
    this.waitForNewLine = false,
  });

  Confirm.withTheme({
    @required this.prompt,
    @required this.theme,
    this.defaultValue,
    this.waitForNewLine = false,
  });

  @override
  _ConfirmState createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  bool answer;

  @override
  void init() {
    super.init();
    answer = widget.defaultValue;
    context.console.hideCursor();
  }

  @override
  void dispose() {
    super.dispose();

    context.erasePreviousLine();

    context.console.writeLine(promptSuccess(
      theme: widget.theme,
      message: widget.prompt,
      value: answer ? 'yes' : 'no',
    ));

    context.console.showCursor();
  }

  @override
  void render(Context context) {
    if (context.renderCount > 0) {
      context.erasePreviousLine();
    }

    final line = StringBuffer();

    line.write(promptInput(
      theme: widget.theme,
      message: widget.prompt,
      hint: 'y/n',
    ));

    if (answer != null) {
      line.write(widget.theme.promptTheme.defaultStyle(answer ? 'yes' : 'no'));
    }
    context.console.writeLine(line.toString());
  }

  @override
  bool interact() {
    while (true) {
      final key = context.readKey();

      if (key.isControl) {
        if (key.controlChar == ControlCharacter.enter &&
            answer != null &&
            widget.waitForNewLine) {
          return answer;
        }
      } else {
        switch (key.char) {
          case 'y':
          case 'Y':
            setState(() {
              answer = true;
            });
            if (!widget.waitForNewLine) {
              return answer;
            }
            break;
          case 'n':
          case 'N':
            setState(() {
              answer = false;
            });
            if (!widget.waitForNewLine) {
              return answer;
            }
            break;
          default:
            break;
        }
      }
    }
  }
}
