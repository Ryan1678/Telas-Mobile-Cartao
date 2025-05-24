import 'package:flutter/material.dart';
import 'salgados.dart';
import 'bebidas.dart';
import 'doces.dart';
import 'sorvetes.dart';
import 'carrinho.dart';
import 'perfil.dart';

class CategoriasScreen extends StatelessWidget {
  const CategoriasScreen({super.key});

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CarrinhoScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PerfilScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 32, left: 24),
              child: Text(
                'Categorias',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 22,
                  crossAxisSpacing: 22,
                  children: [
                    CategoriaCard(
                      image: 'assets/images/Chips.jpg',
                      title: 'Salgados',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SalgadosScreen(),
                          ),
                        );
                      },
                    ),
                    CategoriaCard(
                      image: 'assets/images/doces.jpg',
                      title: 'Doces',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DocesScreen(),
                          ),
                        );
                      },
                    ),
                    CategoriaCard(
                      image: 'assets/images/bebida.png',
                      title: 'Bebidas',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BebidasScreen(),
                          ),
                        );
                      },
                    ),
                    CategoriaCard(
                      image: 'assets/images/picoles.jpg',
                      title: 'Sorvetes',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SorvetesScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) => _onTap(context, index),
      ),
    );
  }
}

class CategoriaCard extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback? onTap;

  const CategoriaCard({
    super.key,
    required this.image,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12), // Menor padding para mais espaço útil
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  image,
                  height: 72, // Tamanho reduzido
                  width: 72,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12), // Menor espaçamento entre imagem e texto
            Padding(
              padding: const EdgeInsets.only(left: 4), // Pequeno espaçamento à esquerda
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF002147), // Azul marinho
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MyBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const MyBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        selectedItemColor: Colors.pinkAccent.shade400,
        unselectedItemColor: Colors.grey.shade500,
        currentIndex: currentIndex,
        onTap: onTap,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }
}
