import 'dart:math';

import 'package:dart_console/dart_console.dart';
import 'package:interact/src/framework/framework.dart';
import 'package:interact/src/theme/theme.dart';
import 'package:interact/src/utils/prompt.dart';

/// A selector component.
class WindowedSelect extends Component<int> {
  /// Constructs a [WindowedSelect] component with the default theme.
  WindowedSelect({
    required this.prompt,
    required this.options,
    this.initialIndex = 0,
    this.windowSize = 5,
  }) : theme = Theme.defaultTheme;

  /// Constructs a [WindowedSelect] component with the supplied theme.
  WindowedSelect.withTheme({
    required this.prompt,
    required this.options,
    required this.theme,
    this.initialIndex = 0,
    this.windowSize = 5,
  });

  /// The theme of the component.
  final Theme theme;

  /// The prompt to be shown together with the user's input.
  final String prompt;

  /// The index to be selected by default.
  ///
  /// Will be `0` by default.
  final int initialIndex;

  /// The number of options to show on screen at once
  ///
  /// Will be `5` by default
  late int windowSize;

  /// The [List] of available [String] options to show
  /// to the user.
  final List<String> options;

  @override
  // ignore: library_private_types_in_public_api
  _SelectState createState() => _SelectState();
}

class _SelectState extends State<WindowedSelect> {
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

    if (component.windowSize < 1) {
      throw Exception("Window size must be at least one");
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
    final currentWindowStart =
        (index / component.windowSize).floor() * component.windowSize;

    final currentWindowEnd = min(
      currentWindowStart + component.windowSize,
      component.options.length,
    );

    for (var i = currentWindowStart; i < currentWindowEnd; i++) {
      final option = component.options[i];
      final line = StringBuffer();

      if (option == component.options[index]) {
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
