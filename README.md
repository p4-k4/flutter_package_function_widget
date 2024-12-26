# flutter_package_function_widget

A Flutter package that provides a macro to generate StatelessWidget from a function, reducing boilerplate code.

## Features

- Simplifies the creation of simple stateless widgets by using a function-based approach
- Reduces boilerplate code for stateless widgets
- Automatically generates a StatelessWidget with fields corresponding to the function's parameters
- Supports both required and optional parameters
- Proper handling of BuildContext

## Getting started

To use this package, add `flutter_package_function_widget` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_package_function_widget: ^0.0.1
```

**Enable Macros:**

Ensure that macro support is enabled in your project by adding the following to your `analysis_options.yaml` file:

```yaml
analyzer:
  enable-experiment:
    - macros
```

## Usage

Annotate a private function with `@DefineWidget()` to generate a corresponding `StatelessWidget`. The function must have `BuildContext` as its first positional parameter.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_package_function_widget/function_widget.dart';

@DefineWidget()
Widget _myWidget(BuildContext context, String title, {String? message}) {
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

// The macro will generate a StatelessWidget named 'MyWidget' that can be used like this:
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
