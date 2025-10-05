import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_comanda/widgets/custom_button.dart';

void main() {
  group('CustomButton Widget Tests', () {
    testWidgets('Renders correctly with text and icon', (
        WidgetTester tester,
        ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Finalizar Pedido',
              icon: const Icon(Icons.check, color: Colors.white),
              onPressed: () {},
              orderTotal: 1,
            ),
          ),
        ),
      );

      expect(find.text('Finalizar Pedido'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('Button is enabled and tappable when orderTotal is positive', (
        WidgetTester tester,
        ) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Tap me',
              orderTotal: 50.0,
              onPressed: () {
                wasPressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CustomButton));
      await tester.pump();

      expect(wasPressed, isTrue);
    });

    testWidgets('Button is disabled and not tappable when orderTotal is zero', (
        WidgetTester tester,
        ) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Tap me',
              orderTotal: 0.0,
              onPressed: () {
                wasPressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CustomButton));
      await tester.pump();

      expect(wasPressed, isFalse);
    });

    testWidgets('Button is disabled and not tappable when orderTotal is null', (
        WidgetTester tester,
        ) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Tap me',
              orderTotal: null,
              onPressed: () {
                wasPressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CustomButton));
      await tester.pump();

      expect(wasPressed, isFalse);
    });

    testWidgets('Displays inactive gradient when disabled', (
        WidgetTester tester,
        ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Disabled',
              orderTotal: 0,
              onPressed: () {},
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.descendant(
        of: find.byType(CustomButton),
        matching: find.byType(Container),
      ));

      final decoration = container.decoration as BoxDecoration;
      final gradient = decoration.gradient as LinearGradient;

      final expectedColors = [Colors.grey.shade300, Colors.grey.shade400];

      expect(gradient.colors, equals(expectedColors));
    });

    testWidgets('Displays active gradient when enabled', (
        WidgetTester tester,
        ) async {
      final customColors = ['FF6347', 'FF4500'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Enabled',
              orderTotal: 1,
              onPressed: () {},
              gradientColors: customColors,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.descendant(
        of: find.byType(CustomButton),
        matching: find.byType(Container),
      ));

      final decoration = container.decoration as BoxDecoration;
      final gradient = decoration.gradient as LinearGradient;

      final expectedColors = [
        const Color(0xFFFF6347),
        const Color(0xFFFF4500)
      ];

      expect(gradient.colors, equals(expectedColors));
    });
  });
}

