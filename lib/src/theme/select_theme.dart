part of clyde.theme;

class SelectTheme {
  final String activeItemPrefix;
  final String inactiveItemPrefix;
  final StyleFunction activeItemStyle;
  final StyleFunction inactiveItemStyle;

  const SelectTheme({
    @required this.activeItemPrefix,
    @required this.inactiveItemPrefix,
    @required this.activeItemStyle,
    @required this.inactiveItemStyle,
  });
}
