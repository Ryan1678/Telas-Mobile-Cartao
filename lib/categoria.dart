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
        // Estamos aqui, não faz nada
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
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text(
                    'Categorias',  // Título alterado para Menu
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink.shade400, // Texto rosinha simples
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
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
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) => _onTap(context, index),
      ),
    );
  }
}

class CategoriaCard extends StatefulWidget {
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
  State<CategoriaCard> createState() => _CategoriaCardState();
}

class _CategoriaCardState extends State<CategoriaCard>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _pressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _pressed = false;
    });
  }

  void _onTapCancel() {
    setState(() {
      _pressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade300),
          ),
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.asset(
                  widget.image,
                  height: 84,
                  width: 84,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  color: Colors.pink.shade400, // texto rosinha simples no card
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
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
        boxShadow: const [],
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
