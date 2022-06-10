import 'dart:io';
import 'dart:math';
import 'package:dart_console/dart_console.dart';

import 'framework/framework.dart';
import 'theme/theme.dart';
import 'utils/prompt.dart';

/// A grid select or checkbox input component.
class GridSelect extends Component<List<int>> {
  /// Constructs a [GridSelect] component with the default theme.
  GridSelect({
    required this.prompt,
    required this.options,
    this.defaults,
  }) : theme = Theme.defaultTheme;

  /// Constructs a [GridSelect] component with the supplied theme.
  GridSelect.withTheme({
    required this.prompt,
    required this.options,
    required this.theme,
    this.defaults,
  });

  /// The theme of the component.
  final Theme theme;

  /// The prompt to be shown together with the user's input.
  final String prompt;

  /// The [List] of available [String] options to show to
  /// the user.
  final List<String> options;

  /// The default values to indicate which options are checked.
  final List<bool>? defaults;

  @override
  _GridSelectState createState() => _GridSelectState();
}

class _GridSelectState extends State<GridSelect> {
  late List<int> selection;
  late int index;

  late int maxOptionLength;

  @override
  void init() {
    super.init();

    index = 0;
    selection = [];
    if (component.options.isEmpty) {
      throw Exception("Options can't be empty");
    }

    maxOptionLength = component.options.map((e) => e.length).reduce(max);

    if (component.defaults != null) {
      if (component.defaults!.length != component.options.length) {
        throw Exception(
          'Default selections have a different length of '
          '${component.defaults!.length} '
          'than options of ${component.options.length}',
        );
      } else {
        selection.addAll(
          component.defaults!.asMap().entries.where((entry) => entry.value).map((entry) => entry.key),
        );
      }
    }

    context.writeln(promptInput(
      theme: component.theme,
      message: component.prompt,
    ));
    context.hideCursor();
  }

  @override
  void dispose() {
    final values = selection.map((x) => component.options[x]).map(component.theme.valueStyle).join(', ');

    context.writeln(promptSuccess(
      theme: component.theme,
      message: component.prompt,
      value: values,
    ));

    context.showCursor();
    super.dispose();
  }

  @override
  void render() {
    final columns = _columns();
    for (var i = 0; i < component.options.length - 1; i += columns) {
      final line = StringBuffer();
      for (var j = 0; j < columns; j++) {
        final ij = i + j;
        final option = component.options[ij];

        if (component.theme.showActiveCursor) {
          if (ij == index) {
            line.write(component.theme.activeItemPrefix);
          } else {
            line.write(component.theme.inactiveItemPrefix);
          }
          line.write(' ');
        }

        line.write(' ');
        if (selection.contains(ij)) {
          line.write(component.theme.checkedItemPrefix);
        } else {
          line.write(component.theme.uncheckedItemPrefix);
        }

        line.write(' ');
        if (ij == index) {
          line.write(component.theme.activeItemStyle(option));
        } else {
          line.write(component.theme.inactiveItemStyle(option));
        }

        final fill = maxOptionLength - option.length;
        for (var i = fill; i >= 1; i--) {
          line.write(' ');
        }
      }
      context.writeln(line.toString());
    }
  }

  @override
  List<int> interact() {
    while (true) {
      final key = context.readKey();

      if (key.isControl) {
        final columns = _columns();
        switch (key.controlChar) {
          case ControlCharacter.arrowUp:
            setState(() {
              index = (index - columns) % component.options.length;
            });
            break;
          case ControlCharacter.arrowDown:
            setState(() {
              index = (index + columns) % component.options.length;
            });
            break;
          case ControlCharacter.arrowLeft:
            setState(() {
              index = (index - 1) % component.options.length;
            });
            break;
          case ControlCharacter.arrowRight:
            setState(() {
              index = (index + 1) % component.options.length;
            });
            break;

          case ControlCharacter.enter:
            return selection;
          default:
            break;
        }
      } else {
        if (key.char == ' ') {
          setState(() {
            _toggle(index);
          });
        }
      }
    }
  }

  void _toggle(int n) {
    if (selection.contains(n)) {
      selection.remove(n);
    } else {
      selection.add(n);
    }
  }

  int _columns() {
    final columnWidth = maxOptionLength + 6;
    final columns = component.options.length < (stdout.terminalColumns ~/ columnWidth)
        ? component.options.length
        : stdout.terminalColumns ~/ columnWidth;
    return columns;
  }
}
