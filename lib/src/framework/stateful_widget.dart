part of clyde.framework;

abstract class StatefulWidget<T> {
  State createState();
  T interact() {
    final state = createState();

    state._widget = this;
    state.initState(state.context);

    // First render
    state.render(state.context);
    state.context.renderCount++;

    final output = state.interact();
    state.dispose(state.context);

    return output as T;
  }
}
