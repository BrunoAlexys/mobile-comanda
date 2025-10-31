import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_comanda/widgets/custom_appbar.dart';

void main() {
  testWidgets('shows title widget', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(appBar: CustomAppBar(title: const Text('MyTitle'))),
    ));

    expect(find.text('MyTitle'), findsOneWidget);
  });

  test('preferredSize equals kToolbarHeight', () {
    const bar = CustomAppBar();
    expect(bar.preferredSize.height, kToolbarHeight);
  });

  testWidgets('applies backgroundColor to AppBar', (WidgetTester tester) async {
    const color = Colors.red;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(appBar: CustomAppBar(backgroundColor: color)),
    ));

    final appBar = tester.widget<AppBar>(find.byType(AppBar));
    expect(appBar.backgroundColor, color);
  });

  testWidgets('uses flexibleSpace when gradient provided', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar(backgroundColorGradient: [Colors.red, Colors.blue]),
      ),
    ));

    final appBar = tester.widget<AppBar>(find.byType(AppBar));
    expect(appBar.flexibleSpace, isNotNull);
    expect(appBar.flexibleSpace, isA<Container>());
  });

  testWidgets('shows leading and action widgets', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar(
          leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
          actions: const [Icon(Icons.search)],
        ),
      ),
    ));

    expect(find.byIcon(Icons.menu), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });
}
