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
abstract class Component<T extends dynamic> {
  /// Creates a [State] for current component,
  /// inspired by Flutter's [StatefulWidget].
  State createState();

  /// Disposes current state, to make the [Context] null and unusable
  /// after the rendering is completely finished.
  ///
  /// Exposed with the purpose to be overriden by [Spinner] and [Progress]
  /// components which dispose the context only when the `done` function
  /// is called.
  void disposeState(State state) => state.dispose();

  /// Pipes the state after running `createState` in case of
  /// needing to handle the state from outside.
  State pipeState(State state) => state;

  // Temporarily stores the number of lines written
  // by the `init()` here
  // to clean them up after `dispose()`
  int _initLinesCount = 0;

  /// Starts the rendering processs.
  ///
  /// Handles not only rendering the `interact` function from the [State]
  /// but also the lifecycle methods such as `init` and `dispose`.
  /// Also does the initial rendering.
  T interact() {
    // Initialize the state
    final state = pipeState(createState());
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
    state.context.wipe();

    // Dispose the lines written by `init()`
    state.context.erasePreviousLine(_initLinesCount);
    disposeState(state);

    return output as T;
  }
}
