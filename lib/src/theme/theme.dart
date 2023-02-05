// ignore_for_file: public_member_api_docs
// ---
// I can't write docs comments for all of [Theme] properties,
// it's too much.
// But I did use expressive names, so it should be good.

import 'package:tint/tint.dart';

/// [Function] takes a [String] and returns a [String].
///
/// Used for styling texts in the [Theme].
typedef StyleFunction = String Function(String);

/// The theme to be used by components.
class Theme {
  /// Constructs a new [Theme] with all of it's properties.
  const Theme({
    required this.inputPrefix,
    required this.inputSuffix,
    required this.successPrefix,
    required this.successSuffix,
    required this.errorPrefix,
    required this.hiddenPrefix,
    required this.messageStyle,
    required this.errorStyle,
    required this.hintStyle,
    required this.valueStyle,
    required this.defaultStyle,
    required this.activeItemPrefix,
    required this.inactiveItemPrefix,
    required this.activeItemStyle,
    required this.inactiveItemStyle,
    required this.checkedItemPrefix,
    required this.uncheckedItemPrefix,
    required this.pickedItemPrefix,
    required this.unpickedItemPrefix,
    required this.showActiveCursor,
    required this.progressPrefix,
    required this.progressSuffix,
    required this.emptyProgress,
    required this.filledProgress,
    required this.leadingProgress,
    required this.emptyProgressStyle,
    required this.filledProgressStyle,
    required this.leadingProgressStyle,
    required this.spinners,
    required this.spinningInterval,
  });

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
  final StyleFunction emptyProgressStyle;
  final StyleFunction filledProgressStyle;
  final StyleFunction leadingProgressStyle;

  final List<String> spinners;
  final int spinningInterval;

  /// Copy current theme with new properties and create a
  /// new [Theme] from it.
  Theme copyWith({
    String? inputPrefix,
    String? inputSuffix,
    String? successPrefix,
    String? successSuffix,
    String? errorPrefix,
    String? hiddenPrefix,
    StyleFunction? messageStyle,
    StyleFunction? errorStyle,
    StyleFunction? hintStyle,
    StyleFunction? valueStyle,
    StyleFunction? defaultStyle,
    String? activeItemPrefix,
    String? inactiveItemPrefix,
    StyleFunction? activeItemStyle,
    StyleFunction? inactiveItemStyle,
    String? checkedItemPrefix,
    String? uncheckedItemPrefix,
    String? pickedItemPrefix,
    String? unpickedItemPrefix,
    bool? showActiveCursor,
    String? progressPrefix,
    String? progressSuffix,
    String? emptyProgress,
    String? filledProgress,
    String? leadingProgress,
    StyleFunction? emptyProgressStyle,
    StyleFunction? filledProgressStyle,
    StyleFunction? leadingProgressStyle,
    List<String>? spinners,
    int? spinningInterval,
  }) {
    return Theme(
      inputPrefix: inputPrefix ?? this.inputPrefix,
      inputSuffix: inputSuffix ?? this.inputSuffix,
      successPrefix: successPrefix ?? this.successPrefix,
      successSuffix: successSuffix ?? this.successSuffix,
      errorPrefix: errorPrefix ?? this.errorPrefix,
      hiddenPrefix: hiddenPrefix ?? this.hiddenPrefix,
      messageStyle: messageStyle ?? this.messageStyle,
      errorStyle: errorStyle ?? this.errorStyle,
      hintStyle: hintStyle ?? this.hintStyle,
      valueStyle: valueStyle ?? this.valueStyle,
      defaultStyle: defaultStyle ?? this.defaultStyle,
      activeItemPrefix: activeItemPrefix ?? this.activeItemPrefix,
      inactiveItemPrefix: inactiveItemPrefix ?? this.inactiveItemPrefix,
      activeItemStyle: activeItemStyle ?? this.activeItemStyle,
      inactiveItemStyle: inactiveItemStyle ?? this.inactiveItemStyle,
      checkedItemPrefix: checkedItemPrefix ?? this.checkedItemPrefix,
      uncheckedItemPrefix: uncheckedItemPrefix ?? this.uncheckedItemPrefix,
      pickedItemPrefix: pickedItemPrefix ?? this.pickedItemPrefix,
      unpickedItemPrefix: unpickedItemPrefix ?? this.unpickedItemPrefix,
      showActiveCursor: showActiveCursor ?? this.showActiveCursor,
      progressPrefix: progressPrefix ?? this.progressPrefix,
      progressSuffix: progressSuffix ?? this.progressSuffix,
      emptyProgress: emptyProgress ?? this.emptyProgress,
      filledProgress: filledProgress ?? this.filledProgress,
      leadingProgress: leadingProgress ?? this.leadingProgress,
      emptyProgressStyle: emptyProgressStyle ?? this.emptyProgressStyle,
      filledProgressStyle: filledProgressStyle ?? this.filledProgressStyle,
      leadingProgressStyle: leadingProgressStyle ?? this.leadingProgressStyle,
      spinners: spinners ?? this.spinners,
      spinningInterval: spinningInterval ?? this.spinningInterval,
    );
  }

  /// An alias to [colorfulTheme].
  static Theme defaultTheme = colorfulTheme;

  /// A very basic theme without colors.
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
    emptyProgressStyle: (x) => x,
    filledProgressStyle: (x) => x,
    leadingProgressStyle: (x) => x,
    spinners: '⠁⠂⠄⡀⢀⠠⠐⠈'.split(''),
    spinningInterval: 80,
  );

  /// A very colorful theme.
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
    emptyProgressStyle: (x) => x,
    filledProgressStyle: (x) => x,
    leadingProgressStyle: (x) => x,
    spinners: '⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'.split(''),
    spinningInterval: 80,
  );
}
