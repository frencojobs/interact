import 'package:interact/src/framework/framework.dart';
import 'package:interact/src/theme/theme.dart';
import 'package:interact/src/utils/prompt.dart';

/// A password input component.
class Password extends Component<String> {
  /// Constructs a [Password] component with the default theme.
  Password({
    required this.prompt,
    this.confirmation = false,
    this.confirmPrompt,
    this.confirmError,
  }) : theme = Theme.defaultTheme;

  /// Constructs a [Password] component with the supplied theme.
  Password.withTheme({
    required this.theme,
    required this.prompt,
    this.confirmation = false,
    this.confirmPrompt,
    this.confirmError,
  });

  /// The theme for the component.
  final Theme theme;

  /// The prompt to be shown together with the user's input.
  final String prompt;

  /// Indicates whether to ask for the password again to confirm.
  final bool confirmation;

  /// The prompt to be shown when asking for the password
  /// againg to confirm.
  final String? confirmPrompt;

  /// The error message to be shown if the repeated password
  /// did not match the initial password.
  final String? confirmError;

  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  late bool hasError;

  @override
  void init() {
    super.init();
    hasError = false;
  }

  @override
  void dispose() {
    context.writeln(
      promptSuccess(
        theme: component.theme,
        message: component.prompt,
        value: component.theme.hiddenPrefix,
      ),
    );

    super.dispose();
  }

  @override
  void render() {
    if (hasError) {
      context.writeln(
        promptError(
          theme: component.theme,
          message: component.confirmError ?? 'Passwords do not match',
        ),
      );
    }
  }

  @override
  String interact() {
    while (true) {
      hasError = false;
      context.write(
        promptInput(
          theme: component.theme,
          message: component.prompt,
        ),
      );

      final password = context.readLine(noRender: true);

      if (component.confirmation) {
        context.write(
          promptInput(
            theme: component.theme,
            message: component.confirmPrompt ?? component.prompt,
          ),
        );

        final repeated = context.readLine(noRender: true);

        if (password != repeated) {
          setState(() {
            hasError = true;
          });
          continue;
        }
      }

      return password;
    }
  }
}
