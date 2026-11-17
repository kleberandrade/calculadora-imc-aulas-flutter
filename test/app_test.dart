import 'package:calculadora_imc/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Future<void> start(WidgetTester tester) async {
  await tester.pumpWidget(const BmiApp());
  await tester.pumpAndSettle();
}

Future<void> calculate(WidgetTester tester) async {
  final button = find.widgetWithText(FilledButton, 'Calcular IMC');
  await tester.ensureVisible(button);
  await tester.tap(button);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('validates, recovers, calculates and fully resets', (
    tester,
  ) async {
    await start(tester);
    await calculate(tester);
    expect(
      find.text('Informe um número; use vírgula ou ponto decimal.'),
      findsNWidgets(2),
    );
    await tester.enterText(find.byKey(const Key('weight')), '70,5');
    await tester.enterText(find.byKey(const Key('height')), '175');
    await calculate(tester);
    expect(find.text('23,0'), findsOneWidget);
    expect(find.text('Peso saudável'), findsWidgets);
    await tester.enterText(find.byKey(const Key('weight')), '-5');
    await tester.pumpAndSettle();
    expect(find.text('23,0'), findsNothing);
    await calculate(tester);
    expect(
      find.text('Informe um número; use vírgula ou ponto decimal.'),
      findsOneWidget,
    );
    final reset = find.widgetWithText(OutlinedButton, 'Reiniciar');
    await tester.ensureVisible(reset);
    await tester.tap(reset);
    await tester.pumpAndSettle();
    for (final field in tester.widgetList<TextFormField>(
      find.byType(TextFormField),
    )) {
      expect(field.controller!.text, isEmpty);
    }
    expect(find.text('Seu resultado aparece aqui'), findsOneWidget);
    expect(
      find.text('Informe um número; use vírgula ou ponto decimal.'),
      findsNothing,
    );
  });

  testWidgets('changing units clears height, result and errors', (
    tester,
  ) async {
    await start(tester);
    await tester.enterText(find.byKey(const Key('weight')), '70');
    await tester.enterText(find.byKey(const Key('height')), '175');
    await calculate(tester);
    final meters = find.text('Metros');
    await tester.ensureVisible(meters);
    await tester.tap(meters);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('height')))
          .controller!
          .text,
      isEmpty,
    );
    expect(find.text('22,9'), findsNothing);
    await tester.enterText(find.byKey(const Key('height')), '1,75');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.text('22,9'), findsOneWidget);
  });

  testWidgets(
    'narrow screen, large text and keyboard traversal remain usable',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(const BmiApp());
      await tester.pumpAndSettle();
      await tester.showKeyboard(find.byKey(const Key('weight')));
      await tester.enterText(find.byKey(const Key('weight')), '70');
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<EditableText>(find.byType(EditableText).last)
            .focusNode
            .hasFocus,
        isTrue,
      );
      await tester.enterText(find.byKey(const Key('height')), '175');
      await calculate(tester);
      expect(find.text('22,9'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('controls pass accessibility guidelines', (tester) async {
    final handle = tester.ensureSemantics();

    await start(tester);
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    handle.dispose();
  });
}
