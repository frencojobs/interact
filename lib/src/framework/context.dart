part of clyde.framework;

final c = Console();

class Context {
  final Console console = c;
  int renderCount;

  Context({this.renderCount = 0});
}
