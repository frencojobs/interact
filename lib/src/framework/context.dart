part of clyde.framework;

final c = Console();

/// Context for both [StatefulWidget] and [StatelessWidget].
class Context {
  /// Console object to do stuffs on Terminal,
  /// comes from `dart_console` library.
  final Console console = c;

  /// Number to keep track of the times the render method
  /// has called from a context.
  int renderCount;

  /// Reset the context, set `renderCount` to `0`
  void reset() {
    renderCount = 0;
  }

  Context({this.renderCount = 0});
}
