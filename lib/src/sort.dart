import 'package:dart_console/dart_console.dart';
import 'package:meta/meta.dart';

import 'framework/framework.dart';
import 'theme/theme.dart';
import 'utils/prompt.dart';

class Sort extends Component<List<String>> {
  final Theme theme;
  final String prompt;
  final bool showOutput;
  final List<String> options;

  Sort({
    @required this.prompt,
    @required this.options,
    this.showOutput = true,
  }) : theme = Theme.defaultTheme;

  Sort.withTheme({
    @required this.prompt,
    @required this.options,
    @required this.theme,
    this.showOutput = true,
  });

  @override
  _SortState createState() => _SortState();
}

class _SortState extends State<Sort> {
  int index;
  int picked;
  List<int> options;

  @override
  void init() {
    if (component.options.isEmpty) {
      throw Exception("Options can't be empty");
    }
    index = 0;
    options =
        component.options.asMap().entries.map((entry) => entry.key).toList();

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
      value: component.showOutput
          ? options.map((i) => component.options[i]).join(', ')
          : '',
    ));
    context.showCursor();
  }

  @override
  void render() {
    for (var i = 0; i < options.length; i++) {
      final option = component.options[options[i]];
      final line = StringBuffer();

      if (component.theme.showActiveCursor) {
        if (i == index) {
          line.write(component.theme.activeItemPrefix);
        } else {
          line.write(component.theme.inactiveItemPrefix);
        }
        line.write(' ');
      }

      if (picked != null && picked == options[i]) {
        line.write(component.theme.pickedItemPrefix);
      } else {
        line.write(component.theme.unpickedItemPrefix);
      }

      line.write(' ');

      if (i == index) {
        line.write(component.theme.activeItemStyle(option));
      } else {
        line.write(component.theme.inactiveItemStyle(option));
      }
      context.writeln(line.toString());
    }
  }

  @override
  List<String> interact() {
    while (true) {
      final key = context.readKey();

      if (key.isControl) {
        switch (key.controlChar) {
          case ControlCharacter.arrowUp:
            setState(() {
              index = (index - 1) % component.options.length;
              if (picked != null) {
                _up();
              }
            });
            break;
          case ControlCharacter.arrowDown:
            setState(() {
              index = (index + 1) % component.options.length;
              if (picked != null) {
                _down();
              }
            });
            break;
          case ControlCharacter.enter:
            return options.map((x) => component.options[x]).toList();
            break;
          default:
            break;
        }
      } else {
        if (key.char == ' ') {
          setState(() {
            _toggle(options[index]);
          });
        }
      }
    }
  }

  void _up() {
    final prev = options.indexOf(picked);
    final next = (prev - 1) % options.length;

    options.remove(picked);
    options.insert(next, picked);
  }

  void _down() {
    final prev = options.indexOf(picked);
    final next = (prev + 1) % options.length;

    options.remove(picked);
    options.insert(next, picked);
  }

  void _toggle(int n) {
    if (picked != null && picked == n) {
      picked = null;
    } else {
      picked = n;
    }
  }
}
