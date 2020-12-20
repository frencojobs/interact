import 'package:meta/meta.dart';

// Project imports:
import 'framework/framework.dart';
import 'theme/theme.dart';
import 'utils/prompt.dart';

class ValidationError {
  final String message;
  ValidationError(this.message);
}

class Input extends StatelessWidget<String> {
  final String prompt;
  final String initialText;
  final String defaultValue;
  final bool Function(String) validator;
  Theme theme = Theme.defaultTheme;

  Input({
    @required this.prompt,
    this.validator,
    this.initialText = '',
    this.defaultValue,
  });

  Input.withTheme({
    @required this.prompt,
    @required this.theme,
    this.validator,
    this.initialText = '',
    this.defaultValue,
  });

  @override
  @protected
  String render(Context context) {
    bool hasError = false;

    while (true) {
      context.console.write(promptInput(
        theme: theme,
        message: prompt,
        hint: defaultValue,
      ));

      final line = context.readLine(
        initialText: initialText,
      );

      if (hasError) {
        context.erasePreviousLine();
      }

      if (validator != null) {
        try {
          validator(line);
        } on ValidationError catch (e) {
          context.erasePreviousLine();

          context.console.writeLine(promptError(
            theme: theme,
            message: e.message,
          ));
          hasError = true;
          continue;
        }
      }

      context.erasePreviousLine();

      final value =
          defaultValue != null ? (line.isEmpty ? defaultValue : line) : line;

      hasError = false;

      context.console.writeLine(
        promptSuccess(
          theme: theme,
          message: prompt,
          value: value,
        ),
      );

      return value;
    }
  }
}
