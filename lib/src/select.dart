import 'dart:math';

import 'package:dart_console/dart_console.dart';
import 'package:interact/src/utils/utils.dart';

import 'framework/framework.dart';
import 'theme/theme.dart';
import 'utils/prompt.dart';

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
  late int maxOptionLength;

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

    maxOptionLength = component.options.map((e) => e.length).reduce(max);

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

    super.dispose();
  }

  @override
  void render() {
    final columns = getColumns(maxOptionLength, component.options.length);
    for (var i = 0; i < component.options.length; i += columns) {
      final line = StringBuffer();
      for (var j = 0; j < columns; j++) {
        final ij = i + j;
        if (ij > component.options.length - 1) break;

        final option = component.options[ij];
        final isActive = ij == index;
        final prefix = isActive ? component.theme.activeItemPrefix : component.theme.inactiveItemPrefix;
        final style = isActive ? component.theme.activeItemStyle(option) : component.theme.inactiveItemStyle(option);

        line.write(prefix);
        line.write(' ');
        line.write(style);

        final fill = maxOptionLength - option.length;
        for (var i = fill; i >= 1; i--) {
          line.write(' ');
        }
      }
      context.writeln(line.toString());
    }
  }

  @override
  int interact() {
    while (true) {
      final key = context.readKey();
      final columns = getColumns(maxOptionLength, component.options.length);
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
          return index;
        default:
          break;
      }
    }
  }
}
