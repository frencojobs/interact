// Package imports:
import 'package:meta/meta.dart';

// Project imports:
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
    value = widget.initialText;
  }

  @override
  void dispose() {
    context.writeln(promptSuccess(
      theme: widget.theme,
      message: widget.prompt,
      value: value,
    ));
  }

  @override
  void render() {
    if (error != null) {
      context.writeln(promptError(
        theme: widget.theme,
        message: error,
      ));
    }
  }

  @override
  String interact() {
    while (true) {
      context.write(promptInput(
        theme: widget.theme,
        message: widget.prompt,
        hint: widget.defaultValue,
      ));
      final line = context.readLine(initialText: widget.initialText);

      if (widget.validator != null) {
        try {
          widget.validator(line);
        } on ValidationError catch (e) {
          setState(() {
            error = e.message;
          });
          continue;
        }
      }

      setState(() {
        if (line.isEmpty && widget.defaultValue != null) {
          value = widget.defaultValue;
        } else {
          value = line;
        }
      });

      return value;
    }
  }
}
