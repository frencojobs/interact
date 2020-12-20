part of clyde.theme;

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
