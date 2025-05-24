import 'package:flutter/material.dart';

class TermosUsoScreen extends StatelessWidget {
  const TermosUsoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Termos de Uso',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.pink),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: const [
            Text(
              '1. Finalidade do Aplicativo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
            ),
            SizedBox(height: 8),
            Text(
              'Este aplicativo tem como objetivo facilitar a compra antecipada de lanches na cantina escolar, permitindo mais praticidade e organização para alunos e responsáveis.',
            ),
            SizedBox(height: 20),

            Text(
              '2. Pagamento e Reembolso',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
            ),
            SizedBox(height: 8),
            Text(
              'Os pagamentos são realizados de forma antecipada via cartão de crédito ou débito. Em caso de ausência do aluno ou erro no pedido, a solicitação de reembolso deverá ser feita diretamente na cantina.',
            ),
            SizedBox(height: 20),

            Text(
              '3. Horário de Funcionamento',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
            ),
            SizedBox(height: 8),
            Text(
              'Os pedidos podem ser realizados de segunda a sexta, até 30 minutos antes do horário de recreio.',
            ),
            SizedBox(height: 20),

            Text(
              '4. Retirada dos Produtos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
            ),
            SizedBox(height: 8),
            Text(
              'Os itens comprados devem ser retirados presencialmente na cantina no horário estipulado. É responsabilidade do aluno fazer a retirada no dia correto.',
            ),
            SizedBox(height: 20),

            Text(
              '5. Privacidade dos Dados',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
            ),
            SizedBox(height: 8),
            Text(
              'Todas as informações pessoais e dados de pagamento são armazenados de forma segura e utilizados apenas para os fins operacionais do aplicativo.',
            ),
            SizedBox(height: 20),

            Text(
              '6. Modificações dos Termos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
            ),
            SizedBox(height: 8),
            Text(
              'Estes termos podem ser atualizados periodicamente. É responsabilidade do usuário consultá-los sempre que necessário.',
            ),
          ],
        ),
      ),
    );
  }
}
