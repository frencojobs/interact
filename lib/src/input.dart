import 'package:meta/meta.dart';

import 'framework/framework.dart';
import 'theme/theme.dart';
import 'utils/prompt.dart';

class ValidationError {
  final String message;
  ValidationError(this.message);
}

class Input extends Component<String> {
  final String prompt;
  final String initialText;
  final String defaultValue;
  final bool Function(String) validator;
  final Theme theme;

  Input({
    @required this.prompt,
    this.validator,
    this.initialText = '',
    this.defaultValue,
  }) : theme = Theme.defaultTheme;

  Input.withTheme({
    @required this.prompt,
    @required this.theme,
    this.validator,
    this.initialText = '',
    this.defaultValue,
  });

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  String value;
  String error;

  @override
  void init() {
    value = component.initialText;
  }

  @override
  void dispose() {
    context.writeln(promptSuccess(
      theme: component.theme,
      message: component.prompt,
      value: value,
    ));
  }

  @override
  void render() {
    if (error != null) {
      context.writeln(promptError(
        theme: component.theme,
        message: error,
      ));
    }
  }

  @override
  String interact() {
    while (true) {
      context.write(promptInput(
        theme: component.theme,
        message: component.prompt,
        hint: component.defaultValue,
      ));
      final input = context.readLine(initialText: component.initialText);
      final line = input.isEmpty && component.defaultValue != null
          ? component.defaultValue
          : input;

      if (component.validator != null) {
        try {
          component.validator(line);
        } on ValidationError catch (e) {
          setState(() {
            error = e.message;
          });
          continue;
        }
      }

      setState(() {
        value = line;
      });

      return value;
    }
  }
}
