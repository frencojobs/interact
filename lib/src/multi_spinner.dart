import 'package:meta/meta.dart';

import 'framework/framework.dart';
import 'spinner.dart';

class BufferContext extends Context {
  final StringBuffer buffer;
  final void Function() setState;

  BufferContext({
    @required this.buffer,
    @required this.setState,
  });

  @override
  void writeln([String text]) {
    buffer.clear();
    buffer.write(text);
    setState();
  }
}

class MultiSpinner {
  final Context _context = Context();
  final List<StringBuffer> _lines = [];
  final List<SpinnerState> _spinners = [];
  final List<void Function()> _disposers = [];

  void dispose(void Function() fn) {
    fn();

    if (_disposers.length == _spinners.length) {
      for (final disposer in _disposers) {
        disposer();
      }
    }
  }

  void render() {
    if (_context.renderCount > 0) {
      _context.erasePreviousLine(_context.linesCount);
      _context.resetLinesCount();
    }

    for (final line in _lines) {
      _context.writeln(line.toString());
    }

    _context.increaseRenderCount();
  }

  SpinnerState add(Spinner spinner) {
    final index = _spinners.length;

    _lines.add(StringBuffer());
    spinner.setContext(BufferContext(
      buffer: _lines[index],
      setState: render,
    ));
    _spinners.add(spinner.interact());

    final state = SpinnerState(done: () {
      final disposer = _spinners[index].done();
      dispose(() {
        _disposers.add(disposer);
      });
      return disposer;
    });

    return state;
  }
}
