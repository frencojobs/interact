part of clyde.framework;

abstract class State<T extends StatefulWidget> {
  final _context = Context();
  Context get context => _context;

  T get widget => _widget;
  T _widget;

  void setState(void Function() fn) {
    fn();
    render(context);
    _context.renderCount++;
  }

  void initState(Context context);
  void render(Context context);
  dynamic interact();
  void dispose(Context context);
}
