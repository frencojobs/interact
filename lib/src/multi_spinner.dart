import 'package:interact/src/framework/framework.dart';
import 'package:interact/src/spinner.dart';

/// A shared context and handler for rendering multiple [Spinner]s.
class MultiSpinner {
  final Context _context = Context();
  final List<StringBuffer> _lines = [];
  final List<SpinnerState> _spinners = [];
  final List<void Function()> _disposers = [];

  void _dispose(void Function() fn) {
    fn();

    if (_disposers.length == _spinners.length) {
      for (final disposer in _disposers) {
        disposer();
      }
    }
  }

  void _render() {
    if (_context.renderCount > 0) {
      _context.erasePreviousLine(_context.linesCount);
      _context.resetLinesCount();
    }

    for (final line in _lines) {
      _context.writeln(line.toString());
    }

    _context.increaseRenderCount();
  }

  /// Adds a new [Spinner] to current [MultiSpinner].
  SpinnerState add(Spinner spinner) {
    final index = _spinners.length;

    _lines.add(StringBuffer());
    spinner.setContext(
      BufferContext(
        buffer: _lines[index],
        setState: _render,
      ),
    );
    _spinners.add(spinner.interact());

    final state = SpinnerState(
      done: () {
        final disposer = _spinners[index].done();
        _dispose(() {
          _disposers.add(disposer);
        });
        return disposer;
      },
    );

    return state;
  }
}
