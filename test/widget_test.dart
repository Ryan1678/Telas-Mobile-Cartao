import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:telasmobile/main.dart'; // ajuste se o nome do seu app for outro

void main() {
  testWidgets('Verifica se a tela de login aparece corretamente', (WidgetTester tester) async {
    // Inicializa o app
    await tester.pumpWidget(const FiebTechApp());

    // Verifica se o texto principal está na tela
    expect(find.text('Você faz parte da\nFIEB TECH?'), findsOneWidget);

    // Verifica se o texto secundário está na tela
    expect(find.text('Venha desfrutar do aplicativo para\nalimentar-se bem!!'), findsOneWidget);

    // Verifica se o botão está presente
    expect(find.widgetWithText(ElevatedButton, 'Faça login'), findsOneWidget);
  });
}
