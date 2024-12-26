# flutter_package_function_widget

A Flutter package that provides a macro to generate StatelessWidget from a function, reducing boilerplate code.

## Features

- Simplifies the creation of simple stateless widgets by using a function-based approach
- Reduces boilerplate code for stateless widgets
- Automatically generates a StatelessWidget with fields corresponding to the function's parameters
- Supports both required and optional parameters
- Proper handling of BuildContext

## Getting started

1. First, ensure you're using Dart SDK 3.6.0 or higher by updating your `pubspec.yaml`:

```yaml
environment:
  sdk: ^3.6.0-0
  flutter: ">=3.0.0"
```

2. Add `flutter_package_function_widget` as a dependency:

```yaml
dependencies:
  flutter_package_function_widget: ^0.0.1
  macros: ^0.1.0
```

3. Enable macro support in your `analysis_options.yaml`:

```yaml
analyzer:
  enable-experiment:
    - macros
```

4. Run `flutter pub get` to update dependencies

## Usage

Use `@DefineWidget()` to generate a StatelessWidget from a function. The macro will create a widget class with the same name as your function (capitalized). Requirements:

1. The first parameter must be of type `BuildContext`
2. Add the Dart 3.6 language version comment at the top of your file

Example:

```dart
// @dart=3.6
import 'package:flutter/material.dart';
import 'package:flutter_package_function_widget/function_widget.dart';

@DefineWidget()
Widget myWidget(BuildContext context, String title, {String? message}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title),
        if (message != null) Text(message),
      ],
    ),
  );
}

// The macro generates a StatelessWidget named 'MyWidget':
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Function Widget Example')),
        body: MyWidget(title: 'Hello', message: 'World'),
      ),
    );
  }
}
```

**Explanation:**

- The `@DefineWidget()` annotation on the `_myWidget` function will generate a `StatelessWidget` class named `MyWidget`
- The parameters `title` and `message` of the function become final fields on the `MyWidget` class
- The `build` method of the generated `MyWidget` class will call the original `_myWidget` function

## Additional information

This package is developed by Paurini Taketakehikuroa Wiringi (p4-k4 on GitHub).

- **GitHub Repository:** [https://github.com/p4-k4/flutter_package_function_widget](https://github.com/p4-k4/flutter_package_function_widget)
- **Author:** Paurini Taketakehikuroa Wiringi

Contributions are welcome! Please feel free to submit issues and pull requests on the GitHub repository.
