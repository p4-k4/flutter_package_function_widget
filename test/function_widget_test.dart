import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:function_widget/function_widget.dart';

@DefineWidget()
Widget testWidget(BuildContext context, String title, {String? message}) {
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

void main() {
  group('DefineWidget', () {
    testWidgets('generates StatelessWidget with custom name',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TestWidget(
            title: 'Hello',
            message: 'World',
          ),
        ),
      );

      expect(find.text('Hello'), findsOneWidget);
      expect(find.text('World'), findsOneWidget);
    });

    testWidgets('handles optional parameters', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TestWidget(
            title: 'Hello',
          ),
        ),
      );

      expect(find.text('Hello'), findsOneWidget);
      expect(find.text('World'), findsNothing);
    });
  });
}
