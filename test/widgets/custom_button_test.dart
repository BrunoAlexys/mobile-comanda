import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_comanda/widgets/custom_button.dart';

Future<void> _pumpTestWidget(WidgetTester tester, {required CustomButton button}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: button),
    ),
  );
}

void main() {
  group('CustomButton Widget Tests', () {
    testWidgets('Renders correctly with text and icon', (tester) async {
      await _pumpTestWidget(
        tester,
        button: CustomButton(
          text: 'Finalizar Pedido',
          icon: const Icon(Icons.check, color: Colors.white),
          onPressed: () {},
        ),
      );

      expect(find.text('Finalizar Pedido'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('Button is enabled and tappable by default', (tester) async {
      bool wasPressed = false;

      await _pumpTestWidget(
        tester,
        button: CustomButton(
          text: 'Tap me',
          onPressed: () => wasPressed = true,
        ),
      );

      await tester.tap(find.byType(CustomButton));
      await tester.pump();

      expect(wasPressed, isTrue);
    });

    testWidgets('Button is disabled and not tappable when isEnabled is false', (tester) async {
      bool wasPressed = false;

      await _pumpTestWidget(
        tester,
        button: CustomButton(
          text: 'Tap me',
          isEnabled: false,
          onPressed: () => wasPressed = true,
        ),
      );

      await tester.tap(find.byType(CustomButton));
      await tester.pump();

      expect(wasPressed, isFalse);
    });

    testWidgets('Displays inactive gradient when isEnabled is false', (tester) async {
      await _pumpTestWidget(
        tester,
        button: CustomButton(
          text: 'Disabled',
          isEnabled: false,
          onPressed: () {},
        ),
      );

      final container = tester.widget<Container>(find.byKey(const Key('custom_button_container')));
      final decoration = container.decoration as BoxDecoration;
      final gradient = decoration.gradient as LinearGradient;

      expect(gradient.colors, [Colors.grey.shade300, Colors.grey.shade400]);
    });

    testWidgets('Displays active gradient when enabled', (tester) async {
      const expectedColors = [Color(0xFFFF6347), Color(0xFFFF4500)];

      await _pumpTestWidget(
        tester,
        button: CustomButton(
          text: 'Enabled',
          isEnabled: true,
          onPressed: () {},
          gradientColors: expectedColors,
        ),
      );

      final container = tester.widget<Container>(find.byKey(const Key('custom_button_container')));
      final decoration = container.decoration as BoxDecoration;
      final gradient = decoration.gradient as LinearGradient;

      expect(gradient.colors, expectedColors);
    });
  });
}
