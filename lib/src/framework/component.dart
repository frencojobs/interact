part of interact.framework;

/// A [Component] is an abstraction made with purpose
/// of writing clear/managed state and rendering for
/// various components this library will create.
///
/// Inspired by Flutter's [StatefulWidget], it's is to be used by
/// the [State] class which is used to manage the state of a [Component].
///
/// Generic [T] is the return type of the [Component] which
/// will be returned from the `interact()` function.
abstract class Component<T> {
  State createState();

  // Temporarily stores the number of lines written
  // by the `init()` here
  // to clean them up after `dispose()`
  int _initLinesCount = 0;

  /// Handles not only rendering the `interact` function from the [State]
  /// but also the lifecycle methods such as `init` and `dispose`.
  /// Also does the initial rendering.
  T interact() {
    // Initialize the state
    final state = createState();
    state._component = this;
    state.init();
    _initLinesCount = state.context.linesCount;
    state.context.resetLinesCount();

    // Render initially for the first time
    state.render();
    state.context.increaseRenderCount();

    // Start interact and render loop
    final output = state.interact();

    // Clean up once again at last for the first render
    state.context.erasePreviousLine(state.context.linesCount);
    state.context.resetLinesCount();

    // Dispose the lines written by `init()`
    state.context.erasePreviousLine(_initLinesCount);
    state.dispose();

    return output as T;
  }
}
