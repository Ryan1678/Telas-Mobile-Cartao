import 'package:flutter/material.dart';

class CarteiraScreen extends StatelessWidget {
  const CarteiraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista simulada de cartões
    final List<Map<String, String>> cartoes = [
      {
        'nome': 'João da Silva',
        'numero': '**** **** **** 1234',
        'validade': '12/26',
      },
      {
        'nome': 'Maria Oliveira',
        'numero': '**** **** **** 5678',
        'validade': '08/25',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Minha Carteira',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.pink.shade400),
        titleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView.separated(
          itemCount: cartoes.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final cartao = cartoes[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.credit_card, size: 32, color: Colors.pink),
                    const SizedBox(height: 16),
                    Text(
                      cartao['numero']!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Nome: ${cartao['nome']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Validade: ${cartao['validade']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
