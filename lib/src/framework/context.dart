part of clyde.framework;

final _defaultConsole = Console();

/// [Context] is used by [Component] and [State] to actually render
/// things to the console, and to act as a state store during rendering,
/// which will store things such as the number or renderings done and the
/// amount of lines used by a specific render, so that the [State] can
/// clear old lines and render new stuffs automatically.
class Context {
  final _console = _defaultConsole;

  int _renderCount = 0;
  int get renderCount => _renderCount;
  void increaseRenderCount() => _renderCount++;
  void resetRenderCount() => _renderCount = 0;

  int _linesCount = 0;
  int get linesCount => _linesCount;
  void increaseLinesCount() => _linesCount++;
  void resetLinesCount() => _linesCount = 0;

  /// Shows the cursor.
  void showCursor() => _console.showCursor();

  /// Hide the cursor.
  void hideCursor() => _console.hideCursor();

  /// Writes a string to the console.
  void write(String text) => _console.write(text);

  /// Increases the number of lines written for the current render,
  /// and writes a line to the the console.
  void writeln([String text, TextAlignment alignment]) {
    increaseLinesCount();
    _console.writeLine(text, alignment);
  }

  /// Erase one line above the current cursor by default.
  ///
  /// If the argument [n] is supplied, it will repeat the process
  /// to [n] times.
  void erasePreviousLine([int n = 1]) {
    for (var i = 0; i < n; i++) {
      _console.cursorUp();
      _console.eraseLine();
    }
  }

  /// Reads a key press, same as dart_console library's
  /// `readKey()` function but this function handles the `Ctrl+C` key
  /// press to immediately exit from the process.
  Key readKey() => _handleKey(_console.readKey());

  /// Reads a line, same as dart_console library's `readLine()` function,
  /// and it's partially taken from the source code of it and modified
  /// for custom use cases, such as accepting initial text as an argument,
  /// and allowing to disable rendering the key press, to use in the [Password]
  /// component.
  String readLine({
    String initialText = '',
    bool noRender = false,
  }) {
    var buffer = initialText;
    var index = buffer.length;

    final screenRow = _console.cursorPosition.row;
    final screenColOffset = _console.cursorPosition.col;
    final bufferMaxLength = _console.windowWidth - screenColOffset - 3;

    if (buffer.isNotEmpty && !noRender) {
      write(buffer);
    }

    while (true) {
      final key = readKey();

      if (key.isControl) {
        switch (key.controlChar) {
          case ControlCharacter.enter:
            writeln();
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
          case ControlCharacter.ctrlU:
            buffer = '';
            index = 0;
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
        _console.cursorPosition = Coordinate(screenRow, screenColOffset);
        _console.eraseCursorToEnd();
        write(buffer);
        _console.cursorPosition =
            Coordinate(screenRow, screenColOffset + index);
      }
    }
  }

  Key _handleKey(Key key) {
    if (key.isControl && key.controlChar == ControlCharacter.ctrlC) {
      exit(1);
    }
    return key;
  }
}
