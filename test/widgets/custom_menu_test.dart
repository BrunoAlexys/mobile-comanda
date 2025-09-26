import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_comanda/widgets/custom_menu.dart';
import 'package:mobile_comanda/util/utils.dart';

void main() {
  group('CustomMenu Widget Tests', () {
    final Color activeColor = Utils.hexToColor('7F1D1D');
    final Color inactiveColor = Colors.grey.shade600;

    testWidgets('Renders correctly with the first item selected by default', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(bottomNavigationBar: CustomMenu())),
      );

      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_rounded), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);

      expect(find.text('Início'), findsOneWidget);
      expect(find.text('Pedidos'), findsOneWidget);
      expect(find.text('Perfil'), findsOneWidget);

      final homeIcon = tester.widget<Icon>(find.byIcon(Icons.home_rounded));
      final homeText = tester.widget<Text>(find.text('Início'));
      expect(homeIcon.color, activeColor);
      expect(homeText.style?.color, activeColor);

      final ordersIcon = tester.widget<Icon>(
        find.byIcon(Icons.shopping_bag_rounded),
      );
      final ordersText = tester.widget<Text>(find.text('Pedidos'));
      expect(ordersIcon.color, inactiveColor);
      expect(ordersText.style?.color, inactiveColor);
    });

    testWidgets('Changes selected item on tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(bottomNavigationBar: CustomMenu())),
      );

      await tester.tap(find.text('Pedidos'));
      await tester.pumpAndSettle();

      final ordersIcon = tester.widget<Icon>(
        find.byIcon(Icons.shopping_bag_rounded),
      );
      final ordersText = tester.widget<Text>(find.text('Pedidos'));
      expect(ordersIcon.color, activeColor);
      expect(ordersText.style?.color, activeColor);

      final homeIcon = tester.widget<Icon>(find.byIcon(Icons.home_rounded));
      final homeText = tester.widget<Text>(find.text('Início'));
      expect(homeIcon.color, inactiveColor);
      expect(homeText.style?.color, inactiveColor);

      await tester.tap(find.text('Perfil'));
      await tester.pumpAndSettle();

      final profileIcon = tester.widget<Icon>(find.byIcon(Icons.person));
      final profileText = tester.widget<Text>(find.text('Perfil'));
      expect(profileIcon.color, activeColor);
      expect(profileText.style?.color, activeColor);

      final ordersIconAfterTap = tester.widget<Icon>(
        find.byIcon(Icons.shopping_bag_rounded),
      );
      expect(ordersIconAfterTap.color, inactiveColor);
    });
  });
}
