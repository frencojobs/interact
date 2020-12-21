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
    if (widget.options.isEmpty) {
      throw Exception("Options can't be empty");
    }

    if (widget.options.length - 1 < widget.initialIndex) {
      throw Exception("Default value is out of options' range");
    } else {
      index = widget.initialIndex;
    }

    context.writeln(promptInput(
      theme: widget.theme,
      message: widget.prompt,
    ));
    context.hideCursor();
  }

  @override
  void dispose() {
    context.writeln(promptSuccess(
      theme: widget.theme,
      message: widget.prompt,
      value: widget.options[index],
    ));
    context.showCursor();
  }

  @override
  void render() {
    for (var i = 0; i < widget.options.length; i++) {
      final option = widget.options[i];
      final line = StringBuffer();

      if (i == index) {
        line.write(widget.theme.selectTheme.activeItemPrefix);
      } else {
        line.write(widget.theme.selectTheme.inactiveItemPrefix);
      }
      line.write(' $option');
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
            index = (index - 1) % widget.options.length;
          });
          break;
        case ControlCharacter.arrowDown:
          setState(() {
            index = (index + 1) % widget.options.length;
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
