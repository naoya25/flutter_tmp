import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  testWidgets('ホームが表示され、2画面目へ遷移できる', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(find.text('トップ画面'), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('ホームから渡したメッセージ'), findsOneWidget);

    await tester.tap(find.text('戻る'));
    await tester.pumpAndSettle();

    expect(find.text('トップ画面'), findsOneWidget);
  });
}
