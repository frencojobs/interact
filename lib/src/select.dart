// Package imports:
import 'package:dart_console/dart_console.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'framework/framework.dart';
import 'theme/theme.dart';
import 'utils/prompt.dart';

class Select extends Component<int> {
  final String prompt;
  final int initialIndex;
  final List<String> options;
  Theme theme = Theme.defaultTheme;

  Select({
    @required this.prompt,
    @required this.options,
    this.initialIndex = 0,
  });

  Select.withTheme({
    @required this.prompt,
    @required this.options,
    @required this.theme,
    this.initialIndex = 0,
  });

  @override
  _SelectState createState() => _SelectState();
}

class _SelectState extends State<Select> {
  int index = 0;

  @override
  void init() {
    if (component.options.isEmpty) {
      throw Exception("Options can't be empty");
    }

    if (component.options.length - 1 < component.initialIndex) {
      throw Exception("Default value is out of options' range");
    } else {
      index = component.initialIndex;
    }

    context.writeln(promptInput(
      theme: component.theme,
      message: component.prompt,
    ));
    context.hideCursor();
  }

  @override
  void dispose() {
    context.writeln(promptSuccess(
      theme: component.theme,
      message: component.prompt,
      value: component.options[index],
    ));
    context.showCursor();
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
          break;
        default:
          break;
      }
    }
  }
}
