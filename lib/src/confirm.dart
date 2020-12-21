// Package imports:
import 'package:dart_console/dart_console.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'framework/framework.dart';
import 'theme/theme.dart';
import 'utils/prompt.dart';

class Confirm extends Component<bool> {
  final Theme theme;
  final String prompt;

  final bool defaultValue;
  final bool waitForNewLine;

  Confirm({
    @required this.prompt,
    this.defaultValue,
    this.waitForNewLine = false,
  }) : theme = Theme.defaultTheme;

  Confirm.withTheme({
    @required this.theme,
    @required this.prompt,
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
    answer = widget.defaultValue;
    context.hideCursor();
  }

  @override
  void dispose() {
    context.writeln(promptSuccess(
      theme: widget.theme,
      message: widget.prompt,
      value: answer ? 'yes' : 'no',
    ));
    context.showCursor();
  }

  @override
  void render() {
    final line = StringBuffer();
    line.write(promptInput(
      theme: widget.theme,
      message: widget.prompt,
      hint: 'y/n',
    ));
    if (answer != null) {
      line.write(widget.theme.promptTheme.defaultStyle(answer ? 'yes' : 'no'));
    }
    context.writeln(line.toString());
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
