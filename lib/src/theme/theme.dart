library clyde.theme;

// Package imports:
import 'package:meta/meta.dart';
import 'package:tint/tint.dart';

typedef StyleFunction = String Function(String);

class Theme {
  final String inputPrefix;
  final String inputSuffix;
  final String successPrefix;
  final String successSuffix;
  final String errorPrefix;
  final StyleFunction errorStyle;
  final StyleFunction hintStyle;
  final StyleFunction valueStyle;
  final StyleFunction defaultStyle;

  final String activeItemPrefix;
  final String inactiveItemPrefix;
  final StyleFunction activeItemStyle;
  final StyleFunction inactiveItemStyle;

  final String checkedItemPrefix;
  final String uncheckedItemPrefix;

  const Theme({
    @required this.inputPrefix,
    @required this.inputSuffix,
    @required this.successPrefix,
    @required this.successSuffix,
    @required this.errorPrefix,
    @required this.errorStyle,
    @required this.hintStyle,
    @required this.valueStyle,
    @required this.defaultStyle,
    @required this.activeItemPrefix,
    @required this.inactiveItemPrefix,
    @required this.activeItemStyle,
    @required this.inactiveItemStyle,
    @required this.checkedItemPrefix,
    @required this.uncheckedItemPrefix,
  });

  static final defaultTheme = Theme(
    inputPrefix: '?'.yellow(),
    inputSuffix: '›'.grey(),
    successPrefix: '✔'.green(),
    successSuffix: '·'.grey(),
    errorPrefix: '✘'.red(),
    errorStyle: (x) => x.red(),
    hintStyle: (x) => x.grey(),
    valueStyle: (x) => x.green(),
    defaultStyle: (x) => x.cyan(),
    activeItemPrefix: '❯'.green(),
    inactiveItemPrefix: ' ',
    activeItemStyle: (x) => x.cyan(),
    inactiveItemStyle: (x) => x,
    checkedItemPrefix: '✔'.green(),
    uncheckedItemPrefix: ' ',
  );
}
