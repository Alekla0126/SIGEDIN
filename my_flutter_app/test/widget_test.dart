import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/screens/home_screen.dart';
import 'package:my_flutter_app/widgets/reusable_widget.dart';

void main() {
  testWidgets('HomeScreen has UCIPS title and summary cards', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    expect(find.text('UCIPS'), findsOneWidget);
    expect(find.text('Documentos registrados: 12'), findsOneWidget);
    expect(find.text('Bienvenido al sistema UCIPS'), findsOneWidget);
    expect(find.byType(ReusableWidget), findsNWidgets(2));
  });

  testWidgets('ReusableWidget displays correct text', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ReusableWidget(text: 'Hello, World!')));

    expect(find.text('Hello, World!'), findsOneWidget);
  });
}