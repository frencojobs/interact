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
  final String defaultValue;
  final bool Function(String) validator;
  Theme theme = Theme.defaultTheme;

  Input({
    @required this.prompt,
    this.validator,
    this.defaultValue,
  });

  Input.withTheme({
    @required this.prompt,
    @required this.theme,
    this.validator,
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

      final line = context.readLine();

      if (hasError) {
        context.console.cursorUp();
        context.console.eraseLine();
      }

      if (validator != null) {
        try {
          validator(line);
        } on ValidationError catch (e) {
          context.console.cursorUp();
          context.console.eraseLine();
          context.console.cursorLeft();

          context.console.writeLine(promptError(
            theme: theme,
            message: e.message,
          ));
          hasError = true;
          continue;
        }
      }

      context.console.cursorUp();
      context.console.eraseLine();
      context.console.cursorLeft();

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
