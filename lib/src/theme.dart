// Package imports:
import 'package:meta/meta.dart';
import 'package:tint/tint.dart';

typedef StyleFunction = String Function(String);

class PromptTheme {
  final String inputPrefix;
  final String inputSuffix;
  final String successPrefix;
  final String successSuffix;
  final String errorPrefix;
  final StyleFunction errorStyle;
  final StyleFunction hintStyle;
  final StyleFunction valueStyle;
  final StyleFunction defaultStyle;

  const PromptTheme({
    @required this.inputPrefix,
    @required this.inputSuffix,
    @required this.successPrefix,
    @required this.successSuffix,
    @required this.errorPrefix,
    @required this.errorStyle,
    @required this.hintStyle,
    @required this.valueStyle,
    @required this.defaultStyle,
  });
}

class SelectTheme {
  final String activeItemPrefix;
  final String inactiveItemPrefix;

  const SelectTheme({
    @required this.activeItemPrefix,
    @required this.inactiveItemPrefix,
  });
}

class Theme {
  final SelectTheme selectTheme;
  final PromptTheme promptTheme;

  const Theme({
    @required this.selectTheme,
    @required this.promptTheme,
  });
}

final defaultTheme = Theme(
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
