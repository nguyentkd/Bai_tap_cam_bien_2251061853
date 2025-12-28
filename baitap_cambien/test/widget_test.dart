// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:baitap_cambien/main.dart';

void main() {
  testWidgets('HomePage renders exercise buttons', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Bài Tập Cảm Biến'), findsOneWidget);
    expect(find.text('Bài 1: Đo Chuyển Động (Lắc)'), findsOneWidget);
    expect(find.text('Bài 2: La Bàn & GPS'), findsOneWidget);
    expect(find.text('Bài 3: Đo Ánh Sáng'), findsOneWidget);

    // Sanity check: there should be 3 main actions.
    expect(find.byType(ElevatedButton), findsNWidgets(3));
  });
}
