import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermosUsoScreen extends StatelessWidget {
  const TermosUsoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Termos de Uso',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.pink.shade600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.pink.shade600),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8BBD0), Color(0xFFFFE4EC), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ListView(
              children: [
                _buildSectionTitle('1. Finalidade do Aplicativo'),
                _buildSectionContent(
                  'Este aplicativo tem como objetivo permitir a recarga antecipada de um cartão virtual utilizado na cantina escolar. A compra de alimentos e produtos é realizada presencialmente na instituição, utilizando o saldo do cartão.',
                ),
                _buildSectionTitle('2. Recarga e Pagamento'),
                _buildSectionContent(
                  'As solicitações devem ser feitas através do aplicativo, e realizando o pagamento de forma presencial na secretaria escolar utilizando cartão de crédito, débito, pix ou dinheiro. O saldo será creditado no cartão virtual do aluno para uso exclusivo na cantina da escola.',
                ),
                _buildSectionTitle('3. Utilização do Saldo'),
                _buildSectionContent(
                  'O saldo disponível no cartão virtual pode ser utilizado apenas para compras presenciais na cantina da escola. Não é possível realizar pedidos ou reservas de produtos através do aplicativo.',
                ),
                _buildSectionTitle('4. Reembolso'),
                _buildSectionContent(
                  'Em caso de erro na recarga ou problemas relacionados ao uso do saldo, o responsável deverá entrar em contato diretamente com a administração da escola para análise e possível reembolso.',
                ),
                _buildSectionTitle('5. Privacidade e Segurança'),
                _buildSectionContent(
                  'As informações pessoais e dados de pagamento são protegidos e utilizados exclusivamente para as operações de recarga e gestão do saldo no cartão virtual.',
                ),
                _buildSectionTitle('6. Atualizações dos Termos'),
                _buildSectionContent(
                  'Estes termos podem ser alterados a qualquer momento. Recomendamos que os usuários verifiquem regularmente as atualizações para se manterem informados.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.pink.shade600,
        ),
      ),
    );
  }

  Widget _buildSectionContent(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.grey.shade800,
          height: 1.5,
        ),
      ),
    );
  }
}
