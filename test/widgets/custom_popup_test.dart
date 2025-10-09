import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_comanda/widgets/custom_popup.dart';

void main() {
  group('CustomPopup Widget Tests', () {
    Future<void> pumpPopup(
        WidgetTester tester, {
          required Widget icon,
          String title = 'Título Padrão',
          String message = 'Mensagem Padrão',
          String confirmButtonText = 'Confirmar',
          required VoidCallback onConfirmPressed,
          String? cancelButtonText,
          VoidCallback? onCancelPressed,
          List<Color>? confirmButtonGradientColors,
          Color? cancelButtonColor,
          Color? titleColor,
          Color? messageColor,
        }) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () => showCustomPopup(
                    context: context,
                    icon: icon,
                    title: title,
                    message: message,
                    confirmButtonText: confirmButtonText,
                    onConfirmPressed: onConfirmPressed,
                    cancelButtonText: cancelButtonText,
                    onCancelPressed: onCancelPressed,
                    confirmButtonGradientColors: confirmButtonGradientColors,
                    cancelButtonColor: cancelButtonColor,
                    titleColor: titleColor,
                    messageColor: messageColor,
                  ),
                  child: const Text('Mostrar Popup'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Mostrar Popup'));
      await tester.pumpAndSettle();
    }

    testWidgets('Deve exibir ícone, título e mensagem', (tester) async {
      await pumpPopup(
        tester,
        icon: const Icon(Icons.check, key: Key('test_icon')),
        title: 'Título de Teste',
        message: 'Mensagem de Teste',
        onConfirmPressed: () {},
      );

      expect(find.byKey(const Key('test_icon')), findsOneWidget);
      expect(find.text('Título de Teste'), findsOneWidget);
      expect(find.text('Mensagem de Teste'), findsOneWidget);
    });

    testWidgets('Deve exibir apenas um botão quando cancelButtonText for nulo',
            (tester) async {
          await pumpPopup(
            tester,
            icon: const Icon(Icons.info),
            confirmButtonText: 'OK',
            onConfirmPressed: () {},
            cancelButtonText: null,
          );

          expect(find.text('OK'), findsOneWidget);
          expect(find.byType(OutlinedButton), findsNothing);
        });

    testWidgets('Deve exibir dois botões quando cancelButtonText for fornecido',
            (tester) async {
          await pumpPopup(
            tester,
            icon: const Icon(Icons.warning),
            confirmButtonText: 'Excluir',
            onConfirmPressed: () {},
            cancelButtonText: 'Cancelar',
            onCancelPressed: () {},
          );

          expect(find.text('Excluir'), findsOneWidget);
          expect(find.text('Cancelar'), findsOneWidget);
          expect(find.byType(OutlinedButton), findsOneWidget);
        });

    testWidgets(
        'Deve chamar onConfirmPressed quando o botão de confirmação for tocado',
            (tester) async {
          bool wasPressed = false;
          await pumpPopup(
            tester,
            icon: const Icon(Icons.touch_app),
            confirmButtonText: 'Tocar',
            onConfirmPressed: () {
              wasPressed = true;
            },
          );

          await tester.tap(find.text('Tocar'));
          await tester.pump();

          expect(wasPressed, isTrue);
        });

    testWidgets(
        'Deve chamar onCancelPressed quando o botão de cancelar for tocado',
            (tester) async {
          bool wasPressed = false;
          await pumpPopup(
            tester,
            icon: const Icon(Icons.touch_app),
            confirmButtonText: 'Confirmar',
            onConfirmPressed: () {},
            cancelButtonText: 'Cancelar Ação',
            onCancelPressed: () {
              wasPressed = true;
            },
          );

          await tester.tap(find.text('Cancelar Ação'));
          await tester.pump();

          expect(wasPressed, isTrue);
        });

    testWidgets('Deve aplicar cores e gradiente personalizados corretamente',
            (tester) async {
          final gradientColors = [Colors.orange, Colors.red];

          await pumpPopup(
            tester,
            icon: const Icon(Icons.color_lens),
            title: 'Teste de Cores',
            message: 'Mensagem Colorida',
            confirmButtonText: 'Confirmar Colorido',
            onConfirmPressed: () {},
            cancelButtonText: 'Cancelar Colorido',
            onCancelPressed: () {},
            titleColor: Colors.blue,
            messageColor: Colors.purple,
            confirmButtonGradientColors: gradientColors,
            cancelButtonColor: Colors.teal,
          );

          final title = tester.widget<Text>(find.text('Teste de Cores'));
          expect(title.style?.color, Colors.blue);

          final message = tester.widget<Text>(find.text('Mensagem Colorida'));
          expect(message.style?.color, Colors.purple);

          final cancelButton =
          tester.widget<OutlinedButton>(find.widgetWithText(OutlinedButton, 'Cancelar Colorido'));
          expect(cancelButton.style?.foregroundColor?.resolve({}), Colors.teal);

          final container = tester.widget<Container>(
            find.ancestor(
              of: find.text('Confirmar Colorido'),
              matching: find.byType(Container),
            ).first,
          );
          final decoration = container.decoration as BoxDecoration;
          final gradient = decoration.gradient as LinearGradient;
          expect(gradient.colors, gradientColors);
        });
  });
}