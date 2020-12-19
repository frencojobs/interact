part of clyde.framework;

abstract class StatelessWidget<T> {
  Context get context => Context();

  @protected
  T render(Context context);

  T interact() {
    return render(context);
  }
}
