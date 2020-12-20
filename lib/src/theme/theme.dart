library clyde.theme;

// Package imports:
import 'package:meta/meta.dart';
import 'package:tint/tint.dart';

part 'prompt_theme.dart';
part 'select_theme.dart';

typedef StyleFunction = String Function(String);

class Theme {
  final SelectTheme selectTheme;
  final PromptTheme promptTheme;

  const Theme({
    @required this.selectTheme,
    @required this.promptTheme,
  });

  static final defaultTheme = Theme(
    selectTheme: SelectTheme(
      activeItemPrefix: '❯'.green(),
      inactiveItemPrefix: ' ',
    ),
    promptTheme: PromptTheme(
      inputPrefix: '?'.yellow(),
      inputSuffix: '›'.grey(),
      successPrefix: '✔'.green(),
      successSuffix: '·'.grey(),
      errorPrefix: '✘'.red(),
      errorStyle: (x) => x.red(),
      hintStyle: (x) => x.grey(),
      valueStyle: (x) => x.green(),
      defaultStyle: (x) => x.cyan(),
    ),
  );
}
