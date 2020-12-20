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

/// Context for both [StatelessWidget] and [StatefulWidget]
class Context {
  /// Console object to do stuffs on Terminal,
  /// comes from `dart_console` library
  final Console console = c;

  void erasePreviousLine() {
    console.cursorUp();
    console.eraseLine();
  }

  /// Method to read a single key from the input,
  /// as replacement for `console.readKey` by
  /// handling process level escape keys from parent
  Key readKey() => handleKey(console.readKey());

  /// This method is taken from `dart_console` library and added
  /// custom functionalities for custom use cases
  String readLine({
    @required String initialText,
    bool noRender = false,
    Function(String text, Key lastPressed) callback,
  }) {
    var buffer = initialText;
    var index = buffer.length;

    final screenRow = console.cursorPosition.row;
    final screenColOffset = console.cursorPosition.col;

    final bufferMaxLength = console.windowWidth - screenColOffset - 3;

    // Render once first if buffer is not empty
    if (buffer.isNotEmpty && !noRender) {
      console.cursorPosition = Coordinate(screenRow, screenColOffset);
      console.eraseCursorToEnd();
      console.write(buffer); // allow for backspace condition
      console.cursorPosition = Coordinate(screenRow, screenColOffset + index);
    }

    while (true) {
      final key = readKey();

      if (key.isControl) {
        switch (key.controlChar) {
          case ControlCharacter.enter:
            console.writeLine();
            return buffer;
          case ControlCharacter.backspace:
          case ControlCharacter.ctrlH:
            if (index > 0) {
              buffer = buffer.substring(0, index - 1) + buffer.substring(index);
              index--;
            }
            break;
          case ControlCharacter.delete:
          case ControlCharacter.ctrlD:
            if (index < buffer.length - 1) {
              buffer = buffer.substring(0, index) + buffer.substring(index + 1);
            }
            break;
          case ControlCharacter.ctrlK:
            buffer = buffer.substring(0, index);
            break;
          case ControlCharacter.arrowLeft:
          case ControlCharacter.ctrlB:
            index = index > 0 ? index - 1 : index;
            break;
          case ControlCharacter.arrowRight:
          case ControlCharacter.ctrlF:
            index = index < buffer.length ? index + 1 : index;
            break;
          case ControlCharacter.wordLeft:
            if (index > 0) {
              final bufferLeftOfCursor = buffer.substring(0, index - 1);
              final lastSpace = bufferLeftOfCursor.lastIndexOf(' ');
              index = lastSpace != -1 ? lastSpace + 1 : 0;
            }
            break;
          case ControlCharacter.home:
          case ControlCharacter.ctrlA:
            index = 0;
            break;
          case ControlCharacter.end:
          case ControlCharacter.ctrlE:
            index = buffer.length;
            break;
          default:
            break;
        }
      } else {
        if (buffer.length < bufferMaxLength) {
          if (index == buffer.length) {
            buffer += key.char;
            index++;
          } else {
            buffer =
                buffer.substring(0, index) + key.char + buffer.substring(index);
            index++;
          }
        }
      }

      if (!noRender) {
        console.cursorPosition = Coordinate(screenRow, screenColOffset);
        console.eraseCursorToEnd();
        console.write(buffer); // allow for backspace condition
        console.cursorPosition = Coordinate(screenRow, screenColOffset + index);
      }

      if (callback != null) callback(buffer, key);
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
