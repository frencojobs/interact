import 'package:dart_console/dart_console.dart';
import 'package:interact/src/framework/framework.dart';
import 'package:interact/src/theme/theme.dart';
import 'package:interact/src/utils/prompt.dart';

/// A sortable list component.
class Sort extends Component<List<String>> {
  /// Constructs a [Sort] component with the default theme.
  Sort({
    required this.prompt,
    required this.options,
    this.showOutput = true,
  }) : theme = Theme.defaultTheme;

  /// Constructs a [Sort] component with the default theme.
  Sort.withTheme({
    required this.prompt,
    required this.options,
    required this.theme,
    this.showOutput = true,
  });

  /// The theme of the component.
  final Theme theme;

  /// The prompt to be shown together with the user's input.
  final String prompt;

  /// Indicates whether to show the sorted output on the
  /// success prompt or not.
  final bool showOutput;

  /// The [List] of available [String] options to show to
  /// the user.
  final List<String> options;

  @override
  _SortState createState() => _SortState();
}

class _SortState extends State<Sort> {
  late int index;
  int? picked;
  late List<int> options;

  @override
  void init() {
    super.init();

    if (component.options.isEmpty) {
      throw Exception("Options can't be empty");
    }
    index = 0;
    options =
        component.options.asMap().entries.map((entry) => entry.key).toList();

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
        value: component.showOutput
            ? options.map((i) => component.options[i]).join(', ')
            : '',
      ),
    );
    context.showCursor();

    super.dispose();
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
    if (picked != null) {
      final prev = options.indexOf(picked!);
      final next = (prev - 1) % options.length;

      options.remove(picked);
      options.insert(next, picked!);
    }
  }

  void _down() {
    if (picked != null) {
      final prev = options.indexOf(picked!);
      final next = (prev + 1) % options.length;

      options.remove(picked);
      options.insert(next, picked!);
    }
  }

  void _toggle(int n) {
    if (picked != null && picked == n) {
      picked = null;
    } else {
      picked = n;
    }
  }
}
