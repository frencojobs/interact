import 'package:dart_console/dart_console.dart';
import 'package:interact/src/framework/framework.dart';
import 'package:interact/src/theme/theme.dart';
import 'package:interact/src/utils/prompt.dart';

/// A selector component.
class Select extends Component<int> {
  /// Constructs a [Select] component with the default theme.
  Select({
    required this.prompt,
    required this.options,
    this.initialIndex = 0,
  }) : theme = Theme.defaultTheme;

  /// Constructs a [Select] component with the supplied theme.
  Select.withTheme({
    required this.prompt,
    required this.options,
    required this.theme,
    this.initialIndex = 0,
  });

  /// The theme of the component.
  final Theme theme;

  /// The prompt to be shown together with the user's input.
  final String prompt;

  /// The index to be selected by default.
  ///
  /// Will be `0` by default.
  final int initialIndex;

  /// The [List] of available [String] options to show
  /// to the user.
  final List<String> options;

  @override
  _SelectState createState() => _SelectState();
}

class _SelectState extends State<Select> {
  int index = 0;

  @override
  void init() {
    super.init();

    if (component.options.isEmpty) {
      throw Exception("Options can't be empty");
    }

    if (component.options.length - 1 < component.initialIndex) {
      throw Exception("Default value is out of options' range");
    } else {
      index = component.initialIndex;
    }

    context.writeln(
      promptInput(
        theme: component.theme,
        message: component.prompt,
      ),
    );
    context.hideCursor();
  }

  @override
  void dispose() {
    context.writeln(
      promptSuccess(
        theme: component.theme,
        message: component.prompt,
        value: component.options[index],
      ),
    );
    context.showCursor();

    super.dispose();
  }

  @override
  void render() {
    for (var i = 0; i < component.options.length; i++) {
      final option = component.options[i];
      final line = StringBuffer();

      if (i == index) {
        line.write(component.theme.activeItemPrefix);
        line.write(' ');
        line.write(component.theme.activeItemStyle(option));
      } else {
        line.write(component.theme.inactiveItemPrefix);
        line.write(' ');
        line.write(component.theme.inactiveItemStyle(option));
      }
      context.writeln(line.toString());
    }
  }

  @override
  int interact() {
    while (true) {
      final key = context.readKey();

      switch (key.controlChar) {
        case ControlCharacter.arrowUp:
          setState(() {
            index = (index - 1) % component.options.length;
          });
          break;
        case ControlCharacter.arrowDown:
          setState(() {
            index = (index + 1) % component.options.length;
          });
          break;
        case ControlCharacter.enter:
          return index;
        default:
          break;
      }
    }
  }
}
