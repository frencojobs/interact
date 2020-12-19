// Package imports:
import 'package:meta/meta.dart';
import 'package:tint/tint.dart';

// Project imports:
import '../theme.dart';

String promptInput({
  @required Theme theme,
  @required String message,
  String hint,
}) {
  final buffer = StringBuffer();

  buffer.write(theme.promptTheme.inputPrefix);
  buffer.write(' $message '.bold());
  if (hint != null) {
    buffer.write('${theme.promptTheme.hintStyle(hint)} ');
  }
  buffer.write(theme.promptTheme.inputSuffix);

  return buffer.toString();
}

String promptSuccess({
  @required Theme theme,
  @required String message,
  @required String value,
}) {
  final buffer = StringBuffer();

  buffer.write(theme.promptTheme.successPrefix);
  buffer.write(' $message '.bold());
  buffer.write(theme.promptTheme.successSuffix);
  buffer.write(theme.promptTheme.valueStyle(' $value '));

  return buffer.toString();
}
