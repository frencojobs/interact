// Package imports:
import 'package:meta/meta.dart';
import 'package:tint/tint.dart';

// Project imports:
import '../theme/theme.dart';

String promptInput({
  @required Theme theme,
  @required String message,
  String hint,
}) {
  final buffer = StringBuffer();

  buffer.write(theme.promptTheme.inputPrefix);
  buffer.write(' $message '.bold());
  if (hint != null) {
    buffer.write('(${theme.promptTheme.hintStyle(hint)}) ');
  }
  buffer.write(theme.promptTheme.inputSuffix);
  buffer.write(' ');

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

String promptError({
  @required Theme theme,
  @required String message,
}) {
  final buffer = StringBuffer();

  buffer.write(theme.promptTheme.errorPrefix);
  buffer.write(' ${theme.promptTheme.errorStyle(message)} '.bold());

  return buffer.toString();
}
