import 'dart:convert' show JsonEncoder;
import 'dart:io' show stdout, stderr, exit;

import 'package:interact/interact.dart';

void main() {
  final theme = Theme.basicTheme;

  stdout.writeln(
    'This utility will walk you through creating a package.json file.',
  );
  stdout.writeln();
  stdout.writeln('Press ^C at any time to quit.');

  final name = Input.withTheme(
    theme: theme,
    prompt: 'package name',
    defaultValue: 'interact',
    validator: (x) {
      if (x.contains(RegExp(r'[^a-zA-Z\d]'))) {
        throw ValidationError('Contains an invalid character!');
      }
      return true;
    },
  ).interact();

  final version = Input.withTheme(
    theme: theme,
    prompt: 'version',
    defaultValue: '1.0.0',
    validator: (x) {
      if (!RegExp(r'^(\d+\.)?(\d+\.)?(\*|\d+)$').hasMatch(x)) {
        throw ValidationError('Not a valid version!');
      }
      return true;
    },
  ).interact();

  final description = Input.withTheme(
    theme: theme,
    prompt: 'description',
  ).interact();

  final entry = Input.withTheme(
    theme: theme,
    prompt: 'entry point',
    defaultValue: 'index.js',
  ).interact();

  final testCommand = Input.withTheme(
    theme: theme,
    prompt: 'test command',
  ).interact();

  final repo = Input.withTheme(
    theme: theme,
    prompt: 'git repository',
  ).interact();

  final keywords = Input.withTheme(
    theme: theme,
    prompt: 'keywords',
  ).interact();

  final license = Input.withTheme(
    theme: theme,
    prompt: 'license',
    defaultValue: 'ISC',
  ).interact();

  stdout.writeln('About to write this to package.json:');

  final content = <String, dynamic>{
    'name': name,
    'version': version,
    'description': description,
    'entry': entry,
    'repository': <String, String>{
      'type': 'git',
      'url': repo,
    },
    'scripts': <String, String>{
      'test': testCommand.isNotEmpty
          ? testCommand
          : 'echo "Error: no test specified" && exit 1'
    },
    'keywords': keywords.isEmpty ? [] : keywords.split(' '),
    'license': license,
  };

  stdout.writeln();
  stdout.writeln(JsonEncoder.withIndent(''.padLeft(4)).convert(content));
  stdout.writeln();

  final ok = Confirm.withTheme(
    theme: theme,
    prompt: 'Is this OK?',
    defaultValue: true,
    waitForNewLine: true,
  ).interact();

  if (ok) {
    stdout.writeln('Done.');
  } else {
    stderr.writeln('Aborted.');
    exit(1);
  }
}
