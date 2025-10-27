import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_comanda/widgets/custom_alert.dart';

void main() {
  group('Testes para CustomAlert', () {
    testWidgets(
      'deve exibir um alerta de SUCESSO com o ícone e mensagem corretos',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => Center(
                  child: ElevatedButton(
                    onPressed: () => CustomAlert.success(
                      context: context,
                      message: 'Operação concluída!',
                    ),
                    child: const Text('Mostrar Alerta'),
                  ),
                ),
              ),
            ),
          ),
        );

        // Aciona o alerta
        await tester.tap(find.text('Mostrar Alerta'));
        await tester.pump(); // Pump para mostrar o SnackBar

        // Verifica se o alerta foi exibido
        expect(find.text('Operação concluída!'), findsOneWidget);
        expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
      },
    );

    testWidgets(
      'deve exibir um alerta de ERRO com o ícone e mensagem corretos',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => Center(
                  child: ElevatedButton(
                    onPressed: () => CustomAlert.error(
                      context: context,
                      message: 'Falha na operação!',
                    ),
                    child: const Text('Mostrar Alerta'),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Mostrar Alerta'));
        await tester.pump();

        expect(find.text('Falha na operação!'), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
      },
    );

    testWidgets(
      'deve exibir um alerta de AVISO com o ícone e mensagem corretos',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => Center(
                  child: ElevatedButton(
                    onPressed: () => CustomAlert.warning(
                      context: context,
                      message: 'Atenção!',
                    ),
                    child: const Text('Mostrar Alerta'),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Mostrar Alerta'));
        await tester.pump();

        expect(find.text('Atenção!'), findsOneWidget);
        expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
      },
    );

    testWidgets('deve respeitar a duração customizada quando fornecida', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: ElevatedButton(
                  onPressed: () => CustomAlert.success(
                    context: context,
                    message: 'Teste duração',
                    duration: const Duration(seconds: 5),
                  ),
                  child: const Text('Mostrar Alerta'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Mostrar Alerta'));
      await tester.pump();

      final snackBarFinder = find.byType(SnackBar);
      expect(snackBarFinder, findsOneWidget);

      final snackBar = tester.widget<SnackBar>(snackBarFinder);
      expect(snackBar.duration, const Duration(seconds: 5));
    });

    testWidgets('deve usar a duração padrão quando não for fornecida', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: ElevatedButton(
                  onPressed: () => CustomAlert.success(
                    context: context,
                    message: 'Teste duração padrão',
                  ),
                  child: const Text('Mostrar Alerta'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Mostrar Alerta'));
      await tester.pump();

      final snackBarFinder = find.byType(SnackBar);
      expect(snackBarFinder, findsOneWidget);

      final snackBar = tester.widget<SnackBar>(snackBarFinder);
      expect(snackBar.duration, const Duration(seconds: 3));
    });
  });
}
