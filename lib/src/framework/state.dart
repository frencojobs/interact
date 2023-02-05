part of interact.framework;

/// Provides the structure and `setState` function.
abstract class State<T extends Component> {
  Context? _context;

  /// The context of the state.
  Context get context {
    if (_context == null) {
      throw Exception(
        "The state's context is already disposed"
        ' '
        'or is not created initially.',
      );
    }
    return _context!;
  }

  /// Changes the context to a new one, not to be used in normal components
  /// except [MultiSpinner] and [MultiProgress] components which requires
  /// custom context overriding.
  // ignore: use_setters_to_change_properties
  void setContext<U extends Context>(U c) => _context = c;

  T? _component;

  /// The component that is using this state.
  T get component {
    if (_component == null) {
      throw Exception(
        'The state is not bind to a component'
        ' '
        'or is already disposed.',
      );
    }
    return _component!;
  }

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
