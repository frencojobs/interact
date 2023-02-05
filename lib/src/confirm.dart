import 'package:dart_console/dart_console.dart';
import 'package:interact/src/framework/framework.dart';
import 'package:interact/src/theme/theme.dart';
import 'package:interact/src/utils/prompt.dart';

/// A confirm component.
class Confirm extends Component<bool> {
  /// Constructs a [Confirm] component with the default theme.
  Confirm({
    required this.prompt,
    this.defaultValue,
    this.waitForNewLine = false,
  }) : theme = Theme.defaultTheme;

  /// Constructs a [Confirm] component with the supplied theme.
  Confirm.withTheme({
    required this.theme,
    required this.prompt,
    this.defaultValue,
    this.waitForNewLine = false,
  });

  /// The theme of the component.
  final Theme theme;

  /// The prompt to be shown together with the user's input.
  final String prompt;

  /// The value to be used as an initial value.
  final bool? defaultValue;

  /// Determines whether to wait for the Enter key after
  /// the user has responded.
  final bool waitForNewLine;

  @override
  _ConfirmState createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  bool? answer;

  @override
  void init() {
    super.init();
    if (component.defaultValue != null) {
      answer = component.defaultValue;
    }
    context.hideCursor();
  }

  @override
  void dispose() {
    context.writeln(
      promptSuccess(
        theme: component.theme,
        message: component.prompt,
        value: answer! ? 'yes' : 'no',
      ),
    );
    context.showCursor();

    super.dispose();
  }

  @override
  void render() {
    final line = StringBuffer();
    line.write(
      promptInput(
        theme: component.theme,
        message: component.prompt,
        hint: 'y/n',
      ),
    );
    if (answer != null) {
      line.write(component.theme.defaultStyle(answer! ? 'yes' : 'no'));
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
            (component.waitForNewLine || component.defaultValue != null)) {
          return answer!;
        }
      } else {
        switch (key.char) {
          case 'y':
          case 'Y':
            setState(() {
              answer = true;
            });
            if (!component.waitForNewLine) {
              return answer!;
            }
            break;
          case 'n':
          case 'N':
            setState(() {
              answer = false;
            });
            if (!component.waitForNewLine) {
              return answer!;
            }
            break;
          default:
            break;
        }
      }
    }
  }
}
