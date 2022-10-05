import 'dart:io';
import 'dart:math';
import 'package:dart_console/dart_console.dart';
import 'package:interact/src/utils/utils.dart';

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
        final selected =
            selection.contains(ij) ? component.theme.checkedItemPrefix : component.theme.uncheckedItemPrefix;

        if (component.theme.showActiveCursor) {
          line.write(prefix);
          line.write(' ');
        }

        line.write(' ');
        line.write(selected);
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
  List<int> interact() {
    while (true) {
      final key = context.readKey();

      if (key.isControl) {
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
}
