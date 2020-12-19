// Package imports:
import 'package:tint/tint.dart';

class SelectTheme {
  final String activeItemPrefix;
  final String inactiveItemPrefix;

  const SelectTheme({
    this.activeItemPrefix,
    this.inactiveItemPrefix,
  });
}

abstract class DefaultTheme {
  static final selectTheme = SelectTheme(
    activeItemPrefix: '❯'.green(),
    inactiveItemPrefix: ' ',
  );
}
