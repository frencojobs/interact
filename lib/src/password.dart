import 'package:meta/meta.dart';

// Project imports:
import 'framework/framework.dart';
import 'theme/theme.dart';
import 'utils/prompt.dart';

class Password extends StatelessWidget<String> {
  final String prompt;
  final bool confirmation;
  final String confirmPrompt;
  final String confirmError;
  Theme theme = Theme.defaultTheme;

  Password({
    @required this.prompt,
    this.confirmation = false,
    this.confirmPrompt,
    this.confirmError,
  });

  Password.withTheme({
    @required this.theme,
    @required this.prompt,
    this.confirmation = false,
    this.confirmPrompt,
    this.confirmError,
  });

  @override
  @protected
  String render(Context context) {
    int errorCount = 0;

    while (true) {
      context.console.write(promptInput(
        theme: theme,
        message: prompt,
      ));

      final password = context.readLine(
        initialText: '',
        noRender: true,
      );

      if (confirmation) {
        context.console.write(promptInput(
          theme: theme,
          message: confirmPrompt ?? prompt,
        ));

        final repeated = context.readLine(
          initialText: '',
          noRender: true,
        );

        if (password != repeated) {
          context.console.writeLine(promptError(
            theme: theme,
            message: confirmError ?? 'Passwords do not match',
          ));
          errorCount++;
          continue;
        }
      }

      for (var i = 0; i <= errorCount; i++) {
        if (i > 0) {
          // For the error lines which is 1 less than input prompts
          context.erasePreviousLine();
        }

        // For the input prompts
        context.erasePreviousLine();
        if (confirmation) {
          context.erasePreviousLine();
        }
      }

      context.console.writeLine(
        promptSuccess(
          theme: theme,
          message: prompt,
          value: '****',
        ),
      );

      return password;
    }
  }
}
