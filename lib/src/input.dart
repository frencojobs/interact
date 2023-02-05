import 'package:interact/src/framework/framework.dart';
import 'package:interact/src/theme/theme.dart';
import 'package:interact/src/utils/prompt.dart';

/// The error message to be thrown from the [Input] component's
/// validator when there is an error.
class ValidationError {
  /// Constructs a [ValidationError] with given message.
  ValidationError(this.message);

  /// The error message.
  final String message;
}

/// An input component.
class Input extends Component<String> {
  /// Constructs an [Input] component with the default theme.
  Input({
    required this.prompt,
    this.validator,
    this.initialText = '',
    this.defaultValue,
  }) : theme = Theme.defaultTheme;

  /// Constructs an [Input] component with the supplied theme.
  Input.withTheme({
    required this.prompt,
    required this.theme,
    this.validator,
    this.initialText = '',
    this.defaultValue,
  });

  /// The theme for the component.
  final Theme theme;

  /// The prompt to be shown together with the user's input.
  final String prompt;

  /// The initial text to be filled in the input box.
  final String initialText;

  /// The value to be hinted in the [prompt] and will be used
  /// if the user's input is empty.
  final String? defaultValue;

  /// The function that runs with the value after the user has
  /// entered the input. If the function throw a [ValidationError]
  /// instead of returning `true`, the error will be shown and
  /// a new input will be asked.
  final bool Function(String)? validator;

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  String? value;
  String? error;

  @override
  void init() {
    super.init();
    value = component.initialText;
  }

  @override
  void dispose() {
    if (value != null) {
      context.writeln(
        promptSuccess(
          theme: component.theme,
          message: component.prompt,
          value: value!,
        ),
      );
    }
    super.dispose();
  }

  @override
  void render() {
    if (error != null) {
      context.writeln(
        promptError(
          theme: component.theme,
          message: error!,
        ),
      );
    }
  }

  @override
  String interact() {
    while (true) {
      context.write(
        promptInput(
          theme: component.theme,
          message: component.prompt,
          hint: component.defaultValue,
        ),
      );
      final input = context.readLine(initialText: component.initialText);
      final line = input.isEmpty && component.defaultValue != null
          ? component.defaultValue!
          : input;

      if (component.validator != null) {
        try {
          component.validator!(line);
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

      return value!;
    }
  }
}
