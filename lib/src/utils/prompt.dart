import 'package:meta/meta.dart';

import '../theme/theme.dart';

String promptInput({
  @required Theme theme,
  @required String message,
  String hint,
}) {
  final buffer = StringBuffer();

  buffer.write(theme.inputPrefix);
  buffer.write(theme.messageStyle(message));
  if (hint != null) {
    buffer.write(' ');
    buffer.write(theme.hintStyle(hint));
  }
  buffer.write(theme.inputSuffix);
  buffer.write(' ');

  return buffer.toString();
}

String promptSuccess({
  @required Theme theme,
  @required String message,
  @required String value,
}) {
  final buffer = StringBuffer();

  buffer.write(theme.successPrefix);
  buffer.write(theme.messageStyle(message));
  buffer.write(theme.successSuffix);
  buffer.write(theme.valueStyle(' $value '));

  return buffer.toString();
}

String promptError({
  @required Theme theme,
  @required String message,
}) {
  final buffer = StringBuffer();

  buffer.write(theme.errorPrefix);
  buffer.write(theme.errorStyle(message));

  return buffer.toString();
}
