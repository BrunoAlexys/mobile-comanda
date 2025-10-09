import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_comanda/widgets/custom_alert.dart';

void main() {
  group('Testes para showCustomAlert', () {
    Future<void> pumpAlert(
        WidgetTester tester, {
          required AlertType type,
          String message = 'Mensagem de Teste',
          Duration? duration,
        }) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: ElevatedButton(
                  onPressed: () => showCustomAlert(
                    context: context,
                    message: message,
                    type: type,
                    duration: duration ?? const Duration(seconds: 3),
                  ),
                  child: const Text('Mostrar Alerta'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Mostrar Alerta'));
      await tester.pumpAndSettle();
    }

    testWidgets('deve exibir um alerta de SUCESSO com o ícone e mensagem corretos', (tester) async {
      await pumpAlert(tester, type: AlertType.sucesso, message: 'Operação concluída!');

      expect(find.text('Operação concluída!'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    });

    testWidgets('deve exibir um alerta de ERRO com o ícone e mensagem corretos', (tester) async {
      await pumpAlert(tester, type: AlertType.erro, message: 'Falha na operação!');

      expect(find.text('Falha na operação!'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('deve exibir um alerta de AVISO com o ícone e mensagem corretos', (tester) async {
      await pumpAlert(tester, type: AlertType.aviso, message: 'Atenção!');

      expect(find.text('Atenção!'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    });

    testWidgets('deve respeitar a duração customizada quando fornecida', (tester) async {
      await pumpAlert(tester, type: AlertType.sucesso, duration: const Duration(seconds: 5));

      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));

      expect(snackBar.duration, const Duration(seconds: 5));
    });
  });
}