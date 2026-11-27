import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studikasusenam/main.dart';

void main() {
  testWidgets('Catatan Harian smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => const DaftarCatatan(),
          '/tambah': (context) => const TambahCatatan(),
          '/detail': (context) => const DetailCatatan(),
        },
      ),
    );

    expect(find.text('Catatan Harian'), findsOneWidget);
  });
}