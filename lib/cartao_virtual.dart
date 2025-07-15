import 'package:flutter/material.dart';
import 'dart:math';
import 'perfil.dart';
import 'solicitarRecarga.dart';

class CartaoVirtualScreen extends StatefulWidget {
  const CartaoVirtualScreen({super.key});

  @override
  State<CartaoVirtualScreen> createState() => _CartaoVirtualScreenState();
}

class _CartaoVirtualScreenState extends State<CartaoVirtualScreen> {
  final List<Map<String, dynamic>> _cartoes = [];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  bool _showForm = false;

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

    setState(() {
      _cartoes.add({
        'nome': nome,
        'numero': numero,
        'id': id,
        'data': DateTime.now(),
        'saldo': saldo.toStringAsFixed(2),
      });
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
  void dispose() {
    _nomeController.dispose();
    super.dispose();
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
                'Cartões Virtuais',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Center(
                  child: Text(
                    'CRIAR CARTÃO',
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
                        decoration: const InputDecoration(
                          labelText: 'Nome do Cartão',
                          border: OutlineInputBorder(),
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
                        ),
                        child: const Text('Confirmar', style: TextStyle(color: Colors.white)),
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
                    ? const Center(
                        child: Text(
                          'Nenhum cartão criado ainda.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _cartoes.length,
                        itemBuilder: (context, index) {
                          final cartao = _cartoes[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartao['nome'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pink,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '**** **** **** ${cartao['numero'].substring(12)}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF002147),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('ID: ${cartao['id']}'),
                                  Text('Criado em: ${cartao['data'].toString().substring(0, 16)}'),
                                  Text('Saldo: R\$ ${cartao['saldo']}'),
                                ],
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
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 0,
        onTap: _onTap,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: '',
          ),
          // Aqui substitui o ícone do carrinho pelo ícone de cartão (exemplo: credit_card)
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
