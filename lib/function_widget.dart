import 'package:macros/macros.dart';

/// Annotates a function to generate a corresponding StatelessWidget.
///
/// The annotated function must:
/// - Be a private function (start with an underscore).
/// - Have `BuildContext` as its first positional parameter.
///
/// All other parameters of the function will be converted into final
/// fields on the generated StatelessWidget.
macro class DefineWidget implements FunctionDeclarationsMacro {
  /// Creates a new [DefineWidget] instance.
  const DefineWidget();

  @override
  Future<void> buildDeclarationsForFunction(
    FunctionDeclaration function,
    DeclarationBuilder builder,
  ) async {
    if (!function.identifier.name.startsWith('_')) {
      throw ArgumentError(
          'DefineWidget should only be used on private declarations');
    }
    if (function.positionalParameters.isEmpty ||
        function.positionalParameters.first.type.toString() != 'BuildContext') {
      throw ArgumentError(
          'DefineWidget functions must have a BuildContext argument as the first positional argument');
    }

    final widgetName = function.identifier.name
        .replaceRange(0, 1, function.identifier.name[1].toUpperCase());

    final positionalFieldParams = function.positionalParameters.skip(1);

    final constructorParams = <String>[];
    final fieldDeclarations = <String>[];
    final buildArguments = <String>[];

    for (final param in positionalFieldParams) {
      fieldDeclarations.add('final ${param.type} ${param.identifier.name};');
      constructorParams.add('required this.${param.identifier.name},');
      buildArguments.add(param.identifier.name);
    }

    for (final param in function.namedParameters) {
      fieldDeclarations.add('final ${param.type} ${param.identifier.name};');
      constructorParams.add('${param.isRequired ? 'required ' : ''}this.${param.identifier.name},');
      buildArguments.add('${param.identifier.name}: ${param.identifier.name}');
    }

    builder.declareInLibrary(
      DeclarationCode.fromString('''
import 'package:flutter/material.dart';

class $widgetName extends StatelessWidget {
  const $widgetName({super.key, ${constructorParams.join()}});

  ${fieldDeclarations.join('\n  ')}

  @override
  Widget build(BuildContext context) {
    return ${function.identifier.name}(context, ${buildArguments.join(', ')});
  }
}
'''),
    );
  }
}
