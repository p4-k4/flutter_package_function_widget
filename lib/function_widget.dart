import 'package:macros/macros.dart';

/// A macro that annotates a function, which becomes the build method for a
/// generated stateless widget.
///
/// The function must have at least one positional parameter, which is of type
/// BuildContext (and this must be the first parameter).
///
/// Any additional function parameters are turned into fields on the stateless
/// widget.
macro class DefineWidget implements FunctionTypesMacro {
  /// Optional identifier for the generated widget class.
  /// Defaults to removing the leading `_` from the function name and calling
  /// `toUpperCase` on the next character.
  final Identifier? widgetIdentifier;

  /// Creates a new [DefineWidget] instance.
  const DefineWidget({this.widgetIdentifier});

  @override
  Future<void> buildTypesForFunction(
      FunctionDeclaration function, TypeBuilder builder) async {
    if (!function.identifier.name.startsWith('_')) {
      throw ArgumentError(
          'DefineWidget should only be used on private declarations');
    }
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
            .replaceRange(0, 2, function.identifier.name[1].toUpperCase());
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
