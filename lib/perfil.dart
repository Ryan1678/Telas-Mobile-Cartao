import 'package:flutter/material.dart';

import 'carrinho.dart';
import 'categoria.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  void _onTap(BuildContext context, int index) {
    if (index != 2) {
      Widget screen;
      switch (index) {
        case 0:
          screen = const CategoriasScreen();
          break;
        case 1:
          screen = const CarrinhoScreen();
          break;
        default:
          screen = const CategoriasScreen();
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
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            children: [
              Icon(icon, color: Colors.pink.shade400, size: 28),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.pink.shade400,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const CategoriasScreen()),
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
              icon: Icons.list_alt,
              title: 'Meus Pedidos',
              onTap: () {
                print('Meus Pedidos clicado');
                // Pode abrir outra tela aqui
              },
            ),
            _buildPerfilItem(
              context: context,
              icon: Icons.account_balance_wallet,
              title: 'Minha Carteira',
              onTap: () {
                print('Minha Carteira clicado');
              },
            ),
            _buildPerfilItem(
              context: context,
              icon: Icons.credit_card,
              title: 'Adicionar Cartão',
              onTap: () {
                print('Adicionar Cartão clicado');
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
