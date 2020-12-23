import 'package:meta/meta.dart';
import 'package:tint/tint.dart';

typedef StyleFunction = String Function(String);

class Theme {
  final String inputPrefix;
  final String inputSuffix;
  final String successPrefix;
  final String successSuffix;
  final String errorPrefix;
  final String hiddenPrefix;
  final StyleFunction messageStyle;
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

  final String pickedItemPrefix;
  final String unpickedItemPrefix;

  final bool showActiveCursor;

  final String progressPrefix;
  final String progressSuffix;
  final String emptyProgress;
  final String filledProgress;
  final String leadingProgress;

  final String spinner;
  final int spinningInterval;

  const Theme({
    @required this.inputPrefix,
    @required this.inputSuffix,
    @required this.successPrefix,
    @required this.successSuffix,
    @required this.errorPrefix,
    @required this.hiddenPrefix,
    @required this.messageStyle,
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
    @required this.pickedItemPrefix,
    @required this.unpickedItemPrefix,
    @required this.showActiveCursor,
    @required this.progressPrefix,
    @required this.progressSuffix,
    @required this.emptyProgress,
    @required this.filledProgress,
    @required this.leadingProgress,
    @required this.spinner,
    @required this.spinningInterval,
  });

  static final defaultTheme = colorfulTheme;

  static final basicTheme = Theme(
    inputPrefix: '',
    inputSuffix: ':',
    successPrefix: '',
    successSuffix: ':',
    errorPrefix: 'error: ',
    hiddenPrefix: '[hidden]',
    messageStyle: (x) => x,
    errorStyle: (x) => x,
    hintStyle: (x) => '[$x]',
    valueStyle: (x) => x,
    defaultStyle: (x) => x,
    activeItemPrefix: '>',
    inactiveItemPrefix: ' ',
    activeItemStyle: (x) => x,
    inactiveItemStyle: (x) => x,
    checkedItemPrefix: '[x]',
    uncheckedItemPrefix: '[ ]',
    pickedItemPrefix: '[x]',
    unpickedItemPrefix: '[ ]',
    showActiveCursor: true,
    progressPrefix: '[',
    progressSuffix: ']',
    emptyProgress: ' ',
    filledProgress: '#',
    leadingProgress: '#',
    spinner: '⠁⠂⠄⡀⢀⠠⠐⠈',
    spinningInterval: 80,
  );

  static final colorfulTheme = Theme(
    inputPrefix: '?'.padRight(2).yellow(),
    inputSuffix: '›'.padLeft(2).grey(),
    successPrefix: '✔'.padRight(2).green(),
    successSuffix: '·'.padLeft(2).grey(),
    errorPrefix: '✘'.padRight(2).red(),
    hiddenPrefix: '****',
    messageStyle: (x) => x.bold(),
    errorStyle: (x) => x.red(),
    hintStyle: (x) => '($x)'.grey(),
    valueStyle: (x) => x.green(),
    defaultStyle: (x) => x.cyan(),
    activeItemPrefix: '❯'.green(),
    inactiveItemPrefix: ' ',
    activeItemStyle: (x) => x.cyan(),
    inactiveItemStyle: (x) => x,
    checkedItemPrefix: '✔'.green(),
    uncheckedItemPrefix: ' ',
    pickedItemPrefix: '❯'.green(),
    unpickedItemPrefix: ' ',
    showActiveCursor: false,
    progressPrefix: '',
    progressSuffix: '',
    emptyProgress: '░',
    filledProgress: '█',
    leadingProgress: '█',
    spinner: '⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏',
    spinningInterval: 80,
  );
}
