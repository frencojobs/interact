part of clyde.framework;

final c = Console();

/// Top level key handler for reading keys
/// such as `Ctrl+C` to exit from the process.
Key handleKey(Key key) {
  if (key.isControl && key.controlChar == ControlCharacter.ctrlC) {
    exit(1);
  }

  return key;
}

/// Context for [Widget]
class Context {
  /// Console object to do stuffs on Terminal,
  /// comes from `dart_console` library
  final Console console = c;

  /// Method to read a single key from the input,
  /// as replacement for `console.readKey` by
  /// handling process level escape keys from parent
  Key readKey() => handleKey(console.readKey());

  String readLine() {
    final line = console.readLine(cancelOnBreak: true);

    if (line == null) {
      exit(1);
    } else {
      return line;
    }
  }

  /// Number to keep track of the times the render method
  /// has called from a context
  int renderCount;

  /// Reset the context, set `renderCount` to `0`
  void reset() {
    renderCount = 0;
  }

  Context({this.renderCount = 0});
}
