import 'package:meta/meta.dart';

// Project imports:
import 'framework/framework.dart';
import 'theme/theme.dart';
import 'utils/prompt.dart';

class Password extends Component<String> {
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
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  bool hasError;

  @override
  void init() {
    hasError = false;
  }

  @override
  void dispose() {
    context.writeln(
      promptSuccess(
        theme: widget.theme,
        message: widget.prompt,
        value: '****',
      ),
    );
  }

  @override
  void render() {
    if (hasError) {
      context.writeln(promptError(
        theme: widget.theme,
        message: widget.confirmError ?? 'Passwords do not match',
      ));
    }
  }

  @override
  String interact() {
    while (true) {
      hasError = false;
      context.write(promptInput(
        theme: widget.theme,
        message: widget.prompt,
      ));

      final password = context.readLine(noRender: true);

      if (widget.confirmation) {
        context.write(promptInput(
          theme: widget.theme,
          message: widget.confirmPrompt ?? widget.prompt,
        ));

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