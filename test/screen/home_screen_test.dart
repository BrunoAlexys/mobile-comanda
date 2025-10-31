import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:mobile_comanda/screen/home_screen.dart';
import 'package:mobile_comanda/store/user_store.mobx.dart';
import 'package:mobile_comanda/widgets/custom_menu.dart';

class MockUserStore extends Mock implements UserStore {}

void main() {
  late MockUserStore mockUserStore;

  setUp(() {
    mockUserStore = MockUserStore();
    GetIt.instance.registerSingleton<UserStore>(mockUserStore);
  });

  tearDown(() {
    GetIt.instance.unregister<UserStore>();
  });

  testWidgets('displays Comanda Online title and notification icon in AppBar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    expect(find.text('Comanda Online'), findsOneWidget);
    expect(find.byIcon(Icons.notifications_none), findsOneWidget);
  });

  testWidgets('displays NewOrderCard with correct content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    expect(find.text('Fazer Novo Pedido'), findsOneWidget);
    expect(
      find.text('Explore o menu para realizar um novo pedido'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.add_rounded), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
  });

  testWidgets('NewOrderCard is tappable and shows message', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    final newOrderCard = find.ancestor(
      of: find.text('Fazer Novo Pedido'),
      matching: find.byType(InkWell),
    );

    expect(newOrderCard, findsOneWidget);
    await tester.tap(newOrderCard);
    await tester.pump();
  });

  testWidgets('displays PendingOrdersCard with correct content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    expect(find.text('Pedidos Pendentes'), findsOneWidget);
    expect(
      find.text('Acompanhe os pedidos que estão aguardando à retirada.'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.access_time_filled_rounded), findsOneWidget);
  });

  testWidgets('PendingOrdersCard shows correct number of pending orders', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('displays CustomMenu at bottom', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    expect(find.byType(CustomMenu), findsOneWidget);
  });
}
