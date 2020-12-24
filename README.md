# Interact

A collection of customizable interactive command-line components.

## Overview

The library contains a bunch of command-line components that are easy to use and customizable, including text and password inputs, radio or select inputs, checkbox or multiple select inputs, spinners and progress bars. Examples for all the available components can be found in the `example` folder, and the API Documentation section will cover all about them.

As an overview, you can make a `Select` component like this.

```dart
final languages = ['Rust', 'Dart', 'TypeScript'];
final selection = Select(
  prompt: "Your favorite programming language",
  options: languages,
).interact();

print('${languages[selection]}');
```

It will result in something like this,

<img src="https://i.imgur.com/boGsIn4.png" />

## API Documentation

### Components

These are the snippets of components with their properties and arguments. Check the [pub documentation]() to get to know more about them in details.

**Confirm Component**

A confirm component asks the user for a simple yes or no and will return a boolean accordingly.

```dart
final answer = Confirm(
  prompt: "Does it work?",
  defaultValue: true, // this is optional
  waitForNewLine: true, // optional and will be false by default
).interact();
```

If `waitForNewLine` is true, the prompt will wait for an <kbd>Enter</kbd> key from the user regardless of the answer.

**Input Component**

An input component asks the user for a string which could be validated.

```dart
final email = Input(
  prompt: 'Your email',
  defaultValue: '', // optional, will provide the user as a hint
  initialText: '', // optional, will be autofilled in the input
  validator: (String x) { // optional
    if (x.contains('@')) {
      return true;
    } else {
      throw ValidationError('Not a valid email');
    }
  },
).interact();
```

The message passed in the `ValidationError` exception will be shown as an error until the validator returns true.

**Password Component**

A password component behaves pretty much the same as an input component, but the user input will be hidden and by default it has a repeat password validator that checks if two password inputs are the same or not.

```dart
final password = Password(
  prompt: "Password",
  confirmation: true, // optional and will be false by default
  confirmPrompt: "Repeat password", // optional
).interact();
```

**Select Component**

A select component asks the user to make a choice between the options supplied and the index of the chosen option will be returned.

```dart
final languages = ['Rust', 'Dart', 'TypeScript'];

final selection = Select(
  prompt: "Your favorite programming language",
  options: languages,
  initialIndex: 2, // optional, will be 0 by default
).interact();
```

**MultiSelect Component**

A multiselect component asks the user for multiple options check by using the <kbd>SpaceBar</kbd>. Similarly as the select component, the multiselect component will returns a list of selected indexes.

```dart
final answers = MultiSelect(
  prompt: "Let me know your answers",
  options: ["A", "B", "C"],
  defaults: [false, true, false], // optional, will be all false by default
).interact();
```

**Sort Component**

A sort component asks the user to sort the given list of options and returns the list ordered by the user.

```dart
final sorted = Sort(
  prompt: 'Sort Tesla models from favorite to least',
  options: ['S', '3', 'X', 'Y'],
  showOutput: false, // optional, will be false by default
).interact();
```

Sometimes the list given can be massive, so setting the `showOutput` to false make the list to not be shown in the success prompt.

**Spinner and MultiSpinner Components**

A spinner will show a spinning indicator until the user call it's `done` method. When it's done, it shows the icon given in place of the spinner.

```dart
final gift = Spinner(
  icon: '🏆',
  leftPrompt: (done) => '',
  rightPrompt: (done) => done
      ? 'here is a trophy for being patient'
      : 'searching a thing for you',
).interact();

await Future.delayed(const Duration(seconds: 5));
gift.done();
```

Using multiple spinners at once is a common practice, but because the way the library render and rerender things, it's not possible to have multiple them normally. It will break the rendering process of all components.

```dart
final spinners = MultiSpinner();

final horse = spinners.add(Spinner(
  icon: '🐴',
  rightPrompt: (done) => done ? 'finished' : 'waiting',
)); // notice how you don't need to call the `.interact()` function

await Future.delayed(const Duration(seconds: 5));
horse.done();
```

Now you can have multiple of them without breaking things.

**Progress and MultiProgress Components**

A progress component shows a progress bar.

```dart
final progress = Progress(
  length: 1000, // required, the length of the progress to use
  size: 0.5, // optional, will be 1 by default
  rightPrompt: (current) => ' ${current.toString().padLeft(3)}/$length',
).interact();

for (var i = 0; i < 500; i++) {
  await Future.delayed(const Duration(milliseconds: 5));
  progress.increase(2);
}

progress.done();
```

The `size` is the multiplier for the rendered progress bar and it will be 1 by default. `0.5` means the rendered progress bar will be half the width of the terminal.

A `MultiProgress` does pretty much the same as what `MultiSpinner` did for spinners.

```dart
final bars = MultiProgress();

final p1 = bars.add(Progress(
  length: 100,
  rightPrompt: (current) => ' ${current.toString().padLeft(3)}/$length',
)); // notice how you don't need to call the `.interact()` function

for (var i = 0; i < 500; i++) {
  await Future.delayed(const Duration(milliseconds: 5));
  p1.increase(2);
}

p1.done();
```

### Customizing Themes

Because most of the rendered things comes from the theme object which is available for all components, you can customize a lot of them by changing the theme. Changing a theme for a component can by done by using the `withTheme` constructor.

```dart
final progress = Progress.withTheme(
  theme: Theme(),
  length: length,
  rightPrompt: (current) => ' ${current.toString().padLeft(3)}/$length',
).interact();
```

The components used the `Theme.defaultTheme` as theme by default. The `Theme` object has two premade themes,

- `Theme.colorfulTheme` which is made with colorful ASCII/emojis
- `Theme.basicTheme` which is mostly text characters and without colors

and the `Theme.defaultTheme` is colorful theme by default.

Because constructing a theme from scrap requires a lot of properties, you can also extends a theme easily from these two themes.

```dart
import 'package:tint/tint.dart'; // for extension methods
// ...
Theme customTheme = Theme.colorfulTheme.copyWith(
  activeItemPrefix: '👉'
  activeItemStyle: (x) => x.yellow().underline(),
);
```

## Acknowledgement

This library is mostly inspired by [dialouger](https://github.com/mitsuhiko/dialoguer) library from Rust. The lack of properly maintained library for Dart with a well-made API is what pushed me into making this library.

## License

MIT © Frenco Jobs
