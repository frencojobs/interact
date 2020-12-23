part of interact.framework;

typedef VoidCallback = void Function();

/// Provides the structure and `setState` function.
abstract class State<T extends Component> {
  Context _context;
  Context get context => _context;

  T _component;
  T get component => _component;

  /// Runs the [fn] function, erases all lines from the previous
  /// render, and increases the render count after rendering a new state.
  @protected
  void setState(VoidCallback fn) {
    fn();

    context.erasePreviousLine(context.linesCount);
    context.resetLinesCount();
    render();
    context.increaseRenderCount();
  }

  @mustCallSuper
  void init() {
    _context = Context();
  }

  @mustCallSuper
  void dispose() {
    _context = null;
  }

  void render() {}
  dynamic interact();
}
