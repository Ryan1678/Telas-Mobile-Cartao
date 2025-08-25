import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'perfil.dart';
import 'solicitarRecarga.dart';

class CartaoVirtualScreen extends StatefulWidget {
  const CartaoVirtualScreen({super.key});

  @override
  State<CartaoVirtualScreen> createState() => _CartaoVirtualScreenState();
}

class _CartaoVirtualScreenState extends State<CartaoVirtualScreen>
    with TickerProviderStateMixin {
  final List<Map<String, dynamic>> _cartoes = [];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  bool _showForm = false;

  final List<AnimationController> _animControllers = [];

  late final AnimationController _waveAnimationController;

  void _onTap(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SolicitarRecargaScreen()),
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

  void _criarCartaoAutomaticamente(String nome) {
    final random = Random();
    String numero = List.generate(16, (_) => random.nextInt(10)).join();
    double saldo = (random.nextDouble() * 1000);
    int id = random.nextInt(100000);

    final cartao = {
      'nome': nome,
      'numero': numero,
      'id': id,
      'data': DateTime.now(),
      'saldo': saldo.toStringAsFixed(2),
    };

    setState(() {
      _cartoes.add(cartao);

      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );
      _animControllers.add(controller);
      controller.forward();

      _showForm = false;
      _nomeController.clear();
    });
  }

  void _abrirFormulario() {
    setState(() {
      _showForm = true;
    });
  }

  void _salvarFormulario() {
    if (_formKey.currentState!.validate()) {
      _criarCartaoAutomaticamente(_nomeController.text.trim());
    }
  }

  @override
  void initState() {
    super.initState();
    _waveAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _waveAnimationController.dispose();
    for (var controller in _animControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF8BBD0),
              Color(0xFFFFE4EC),
              Colors.white
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 32, left: 24),
                child: Text(
                  'Cartões Virtuais',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink.shade400,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ElevatedButton(
                  onPressed: _abrirFormulario,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Center(
                    child: Text(
                      'CRIAR CARTÃO',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              if (_showForm)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nomeController,
                          decoration: InputDecoration(
                            labelText: 'Nome do Cartão',
                            labelStyle: GoogleFonts.poppins(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Digite um nome';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _salvarFormulario,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink.shade400,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Confirmar',
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _cartoes.isEmpty
                      ? Center(
                          child: Text(
                            'Nenhum cartão criado ainda.',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _cartoes.length,
                          itemBuilder: (context, index) {
                            final cartao = _cartoes[index];
                            final animController = _animControllers[index];
                            final animation = Tween<Offset>(
                              begin: const Offset(0, 0.3),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: animController,
                                curve: Curves.easeOut,
                              ),
                            );

                            return FadeTransition(
                              opacity: animController,
                              child: SlideTransition(
                                position: animation,
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.pink.shade300,
                                        Colors.pink.shade100
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.pink.shade100,
                                        blurRadius: 6,
                                        offset: const Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cartao['nome'],
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '**** **** **** ${cartao['numero'].substring(12)}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'ID: ${cartao['id']}',
                                          style: GoogleFonts.poppins(
                                              color: Colors.white70),
                                        ),
                                        Text(
                                          'Criado em: ${cartao['data'].toString().substring(0, 16)}',
                                          style: GoogleFonts.poppins(
                                              color: Colors.white70),
                                        ),
                                        Text(
                                          'Saldo: R\$ ${cartao['saldo']}',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          AnimatedBuilder(
            animation: _waveAnimationController,
            builder: (context, child) {
              return CustomPaint(
                painter: WavePainter(_waveAnimationController.value),
                size: const Size(double.infinity, 100),
              );
            },
          ),
          MyBottomNavigationBar(
            currentIndex: 0,
            onTap: _onTap,
          ),
        ],
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
      decoration: const BoxDecoration(
        color: Colors.transparent,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '',
          ),
        ],
      ),
    );
  }
}

// CustomPainter para desenhar as ondas
class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = Colors.pinkAccent.shade100
      ..style = PaintingStyle.fill;

    final path1 = Path();
    path1.moveTo(0, size.height * 0.6);
    path1.quadraticBezierTo(
        size.width * 0.25,
        size.height * (0.7 + 0.1 * sin(animationValue * 2 * pi)),
        size.width * 0.5,
        size.height * 0.6);
    path1.quadraticBezierTo(
        size.width * 0.75,
        size.height * (0.5 + 0.1 * cos(animationValue * 2 * pi)),
        size.width,
        size.height * 0.6);
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();
    canvas.drawPath(path1, paint1);

    final paint2 = Paint()
      ..color = Colors.pinkAccent.shade100.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, size.height * 0.5);
    path2.quadraticBezierTo(
        size.width * 0.25,
        size.height * (0.6 + 0.1 * cos(animationValue * 2 * pi)),
        size.width * 0.5,
        size.height * 0.5);
    path2.quadraticBezierTo(
        size.width * 0.75,
        size.height * (0.4 + 0.1 * sin(animationValue * 2 * pi)),
        size.width,
        size.height * 0.5);
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
