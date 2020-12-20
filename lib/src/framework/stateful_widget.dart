part of clyde.framework;

abstract class StatefulWidget<T> {
  State createState();
  T interact() {
    final state = createState();

    // Initialize the `widget` of the state
    state._widget = this;
    state.init();

    // Render for the first time and increase the renderCount
    state.render(state.context);
    state.context.renderCount++;

    final output = state.interact();

    // Finally reset the [Context], and clear stuffs
    state.dispose();

    return output as T;
  }
}
