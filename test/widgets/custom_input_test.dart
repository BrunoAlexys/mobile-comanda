import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_comanda/widgets/custom_input.dart';

void main() {
  group('CustomInput Widget Tests', () {
    testWidgets('Renders correctly with label and hint text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomInput(labelText: 'Email', hintText: 'Enter your email'),
          ),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Enter your email'), findsOneWidget);
    });

    testWidgets('Allows text entry and calls onChanged', (
      WidgetTester tester,
    ) async {
      String? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomInput(
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(CustomInput), 'test@example.com');
      await tester.pump();

      expect(find.text('test@example.com'), findsOneWidget);
      expect(changedValue, 'test@example.com');
    });

    testWidgets('Shows error message when validator fails', (
      WidgetTester tester,
    ) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: CustomInput(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      );

      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Please enter some text'), findsOneWidget);
    });

    testWidgets('Obscures text when obscureText is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CustomInput(obscureText: true))),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);
    });
  });
}
