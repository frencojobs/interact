part of clyde.framework;

typedef VoidCallback = void Function();

abstract class State<T extends Widget> {
  Context _context;
  Context get context => _context;

  T get widget => _widget;
  T _widget;

  @protected
  void setState(VoidCallback fn) {
    fn();
    render(context);
    _context.renderCount++;
  }

  @protected
  @mustCallSuper
  void init() {
    _context = Context();
  }

  void render(Context context);
  dynamic interact();

  @protected
  @mustCallSuper
  void dispose() {
    context.reset();
  }
}
