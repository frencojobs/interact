import 'package:interact/src/theme/theme.dart';

/// Generates a formatted input message to prompt.
String promptInput({
  required Theme theme,
  required String message,
  String? hint,
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

/// Generates a success prompt, a message to indicates
/// the interaction is successfully finished.
String promptSuccess({
  required Theme theme,
  required String message,
  required String value,
}) {
  final buffer = StringBuffer();

  buffer.write(theme.successPrefix);
  buffer.write(theme.messageStyle(message));
  buffer.write(theme.successSuffix);
  buffer.write(theme.valueStyle(' $value '));

  return buffer.toString();
}

/// Generates a message to use as an error prompt.
String promptError({
  required Theme theme,
  required String message,
}) {
  final buffer = StringBuffer();

  buffer.write(theme.errorPrefix);
  buffer.write(theme.errorStyle(message));

  return buffer.toString();
}
