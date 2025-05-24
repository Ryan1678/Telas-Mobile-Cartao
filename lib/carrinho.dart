import 'package:flutter/material.dart';
import 'categoria.dart';
import 'perfil.dart';

class CarrinhoScreen extends StatelessWidget {
  const CarrinhoScreen({super.key});

  void _onTap(BuildContext context, int index) {
    if (index != 1) {
      Widget screen;
      switch (index) {
        case 0:
          screen = const CategoriasScreen();
          break;
        case 2:
          screen = const PerfilScreen();
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

  Widget _buildCartItem({
    required String image,
    required String title,
    required String description,
    required double price,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                image,
                height: 64,
                width: 64,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'R\$ ${price.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.pink.shade400,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Exemplo de itens no carrinho
    final cartItems = [
      {
        'image': 'assets/images/Chips.jpg',
        'title': 'Salgado Especial',
        'description': 'Delicioso e crocante',
        'price': 12.50,
      },
      {
        'image': 'assets/images/doces.jpg',
        'title': 'Doce Caseiro',
        'description': 'Sabor tradicional',
        'price': 8.00,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: const Text('Carrinho'),
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return _buildCartItem(
                  image: item['image'] as String,
                  title: item['title'] as String,
                  description: item['description'] as String,
                  price: item['price'] as double,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade400,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                // Ação de finalizar pedido
                print('Finalizar pedido clicado');
              },
              child: const Text(
                'Finalizar Pedido',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 1,
        onTap: (index) => _onTap(context, index),
      ),
    );
  }
}
