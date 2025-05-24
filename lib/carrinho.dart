import 'package:flutter/material.dart';
import 'categoria.dart';
import 'perfil.dart';
import 'finalizar_pedido.dart';

class CarrinhoScreen extends StatefulWidget {
  const CarrinhoScreen({super.key});

  @override
  _CarrinhoScreenState createState() => _CarrinhoScreenState();
}

class _CarrinhoScreenState extends State<CarrinhoScreen> {
  final List<Map<String, dynamic>> cartItems = [
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

  double get totalPrice =>
      cartItems.fold(0.0, (sum, item) => sum + (item['price'] as double));

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Carrinho',
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
              MaterialPageRoute(
                builder: (_) => const CategoriasScreen(),
              ), // Volta para Categorias
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 20),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            item['image'] as String,
                            height: 74,
                            width: 74,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item['description'] as String,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'R\$ ${item['price'].toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.pink.shade400,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'R\$ ${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink.shade400,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade400,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: const Size.fromHeight(60),
                elevation: 6,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FinalizarPedidoScreen(),
                  ),
                );
              },
              child: const Text(
                'Finalizar Pedido',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
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
