part of interact.framework;

/// Provides the structure and `setState` function.
abstract class State<T extends Component> {
  Context _context;

  /// The context of the state.
  Context get context => _context;

  /// Changes the context to a new one, not to be used in normal components
  /// except [MultiSpinner] and [MultiProgress] components which requires
  /// custom context overriding.
  void setContext<U extends Context>(U c) => _context = c;

  T _component;

  /// The component that is using this state.
  T get component => _component;

  /// Runs the [fn] function, erases all lines from the previous
  /// render, and increases the render count after rendering a new state.
  @protected
  @mustCallSuper
  void setState(void Function() fn) {
    fn();
    context.wipe();
    render();
    context.increaseRenderCount();
  }

  /// Initializes the context if it's `null`.
  @mustCallSuper
  void init() {
    _context ??= Context();
  }

  /// Sets the context to `null`.
  @mustCallSuper
  void dispose() {
    _context = null;
  }

  /// Write lines to the console using the context.
  void render() {}

  /// Starts the rendering process. Will be handled by
  /// the [Component]'s `interact` function.
  dynamic interact();
}
