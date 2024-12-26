// @dart=3.6
import 'package:macros/macros.dart';

/// A macro that generates a StatelessWidget from a function.
///
/// The macro will create a widget class with the same name as your function
/// (capitalized). The function must have a BuildContext as its first parameter.
/// Any additional parameters will become fields on the generated widget.
macro class DefineWidget implements FunctionTypesMacro {
  /// Optional identifier for the generated widget class.
  /// If not provided, the function name will be capitalized.
  final Identifier? widgetIdentifier;

  /// Creates a new [DefineWidget] instance.
  const DefineWidget({this.widgetIdentifier});

  @override
  Future<void> buildTypesForFunction(
      FunctionDeclaration function, TypeBuilder builder) async {
    if (function.positionalParameters.isEmpty ||
        (function.positionalParameters.first.type as NamedTypeAnnotation)
                .identifier
                .name !=
            'BuildContext') {
      throw ArgumentError(
          'DefineWidget functions must have a BuildContext argument as the '
          'first positional argument');
    }

    var widgetName = widgetIdentifier?.name ??
        function.identifier.name
            .replaceRange(0, 1, function.identifier.name[0].toUpperCase());
    var positionalFieldParams = function.positionalParameters.skip(1);
    // ignore: deprecated_member_use
    var statelessWidget = await builder.resolveIdentifier(
        Uri.parse('package:flutter/src/widgets/framework.dart'), 'StatelessWidget');
    // ignore: deprecated_member_use
    var buildContext = await builder.resolveIdentifier(
        Uri.parse('package:flutter/src/widgets/framework.dart'), 'BuildContext');
    // ignore: deprecated_member_use
    var widget = await builder.resolveIdentifier(
        Uri.parse('package:flutter/src/widgets/framework.dart'), 'Widget');
    // ignore: deprecated_member_use
    var override = await builder.resolveIdentifier(
        Uri.parse('dart:core'), 'override');

    builder.declareType(
        widgetName,
        DeclarationCode.fromParts([
          'class $widgetName extends ', statelessWidget, ' {',
          // Fields
          for (var param
              in positionalFieldParams.followedBy(function.namedParameters))
            DeclarationCode.fromParts([
              'final ',
              param.type.code,
              ' ',
              param.identifier.name,
              ';',
            ]),
          // Constructor
          'const $widgetName({',
          'super.key,',
          for (var param in positionalFieldParams)
            'required this.${param.identifier.name},',
          for (var param in function.namedParameters)
            '${param.isRequired ? 'required ' : ''}this.${param.identifier.name},',
          '});',
          // Build method
          DeclarationCode.fromParts(['@', override, '\n']),
          DeclarationCode.fromParts([widget, ' build(', buildContext, ' context) {']),
          '  return ',
          function.identifier.name,
          '(',
          '    context,',
          for (var param in positionalFieldParams) '    ${param.identifier.name},',
          for (var param in function.namedParameters)
            '    ${param.identifier.name}: ${param.identifier.name},',
          '  );',
          '}',
          '}',
        ]));
  }
}
