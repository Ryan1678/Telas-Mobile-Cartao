import 'package:flutter/material.dart';
import 'main.dart';
import 'carteira.dart';
import 'termos_uso.dart';
import 'configurações.dart';
import 'cartao_virtual.dart';
import 'solicitarRecarga.dart';
import 'faleconosco.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  void _onTap(BuildContext context, int index) {
    if (index != 2) {
      Widget screen;
      switch (index) {
        case 0:
          screen = const CartaoVirtualScreen();
          break;
        case 1:
          screen = const SolicitarRecargaScreen();
          break;
        default:
          screen = const CartaoVirtualScreen();
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => screen),
      );
    }
  }

  Widget _buildPerfilItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          child: Row(
            children: [
              Icon(icon, color: Colors.pink.shade400, size: 30),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Perfil',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.pink.shade400),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const CartaoVirtualScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            _buildPerfilItem(
              context: context,
              icon: Icons.settings,
              title: 'Configurações do perfil',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ConfiguracoesPerfilScreen()),
                );
              },
            ),
            _buildPerfilItem(
              context: context,
              icon: Icons.account_balance_wallet,
              title: 'Minha Carteira',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CarteiraScreen()),
                );
              },
            ),
            _buildPerfilItem(
              context: context,
              icon: Icons.description_outlined,
              title: 'Termos de Uso',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TermosUsoScreen()),
                );
              },
            ),
            _buildPerfilItem(
              context: context,
              icon: Icons.support_agent,
              title: 'Fale Conosco',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FaleConoscoScreen()),
                );
              },
            ),
            _buildPerfilItem(
              context: context,
              icon: Icons.logout,
              title: 'Fazer Logoff',
              onTap: () {
                print('Usuário fez logoff');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FiebTechApp()),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 2,
        onTap: (index) => _onTap(context, index),
      ),
    );
  }
}
