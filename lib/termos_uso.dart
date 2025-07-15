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
              'Este aplicativo tem como objetivo permitir a recarga antecipada de um cartão virtual utilizado na cantina escolar. A compra de alimentos e produtos é realizada presencialmente na instituição, utilizando o saldo do cartão.',
            ),
            SizedBox(height: 20),

            Text(
              '2. Recarga e Pagamento',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
            ),
            SizedBox(height: 8),
            Text(
              'As recargas devem ser feitas através do aplicativo utilizando cartão de crédito, débito ou outros meios digitais disponibilizados. O saldo será creditado no cartão virtual do aluno para uso exclusivo na cantina da escola.',
            ),
            SizedBox(height: 20),

            Text(
              '3. Utilização do Saldo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
            ),
            SizedBox(height: 8),
            Text(
              'O saldo disponível no cartão virtual pode ser utilizado apenas para compras presenciais na cantina da escola. Não é possível realizar pedidos ou reservas de produtos através do aplicativo.',
            ),
            SizedBox(height: 20),

            Text(
              '4. Reembolso',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
            ),
            SizedBox(height: 8),
            Text(
              'Em caso de erro na recarga ou problemas relacionados ao uso do saldo, o responsável deverá entrar em contato diretamente com a administração da escola para análise e possível reembolso.',
            ),
            SizedBox(height: 20),

            Text(
              '5. Privacidade e Segurança',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
            ),
            SizedBox(height: 8),
            Text(
              'As informações pessoais e dados de pagamento são protegidos e utilizados exclusivamente para as operações de recarga e gestão do saldo no cartão virtual.',
            ),
            SizedBox(height: 20),

            Text(
              '6. Atualizações dos Termos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
            ),
            SizedBox(height: 8),
            Text(
              'Estes termos podem ser alterados a qualquer momento. Recomendamos que os usuários verifiquem regularmente as atualizações para se manterem informados.',
            ),
          ],
        ),
      ),
    );
  }
}
