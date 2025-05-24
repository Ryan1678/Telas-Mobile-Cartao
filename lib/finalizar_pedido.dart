import 'package:flutter/material.dart';
import 'adicionar_cartao.dart';
import 'categoria.dart';

class FinalizarPedidoScreen extends StatefulWidget {
  const FinalizarPedidoScreen({super.key});

  @override
  State<FinalizarPedidoScreen> createState() => _FinalizarPedidoScreenState();
}

class _FinalizarPedidoScreenState extends State<FinalizarPedidoScreen> {
  // Itens do pedido (simulados)
  final List<Map<String, dynamic>> pedidoItems = [
    {
      'title': 'Salgado Especial',
      'description': 'Delicioso e crocante',
      'price': 12.50,
      'image': 'assets/images/Chips.jpg',
    },
    {
      'title': 'Doce Caseiro',
      'description': 'Sabor tradicional',
      'price': 8.00,
      'image': 'assets/images/doces.jpg',
    },
  ];

  // Cartões salvos simulados
  final List<Map<String, String>> savedCards = [
    {'cardNumber': '**** **** **** 1234', 'cardHolder': 'João da Silva'},
    {'cardNumber': '**** **** **** 5678', 'cardHolder': 'Maria Oliveira'},
  ];

  int? selectedCardIndex;

  double get totalPrice =>
      pedidoItems.fold(0.0, (sum, item) => sum + (item['price'] as double));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalizar Pedido'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.pink.shade400,
        elevation: 1,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Resumo do Pedido:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Lista de itens
          ...pedidoItems.map((item) {
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  item['image'],
                  height: 48,
                  width: 48,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(item['title']),
              subtitle: Text(item['description']),
              trailing: Text(
                'R\$ ${item['price'].toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.pink.shade400,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }),

          const SizedBox(height: 12),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'R\$ ${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink.shade400,
                ),
              ),
            ],
          ),

          const Divider(height: 32, thickness: 1.2),

          const Text(
            'Escolha um cartão para pagamento:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Cartões salvos
          ...List.generate(savedCards.length, (index) {
            final card = savedCards[index];
            return RadioListTile<int>(
              value: index,
              groupValue: selectedCardIndex,
              onChanged: (value) {
                setState(() {
                  selectedCardIndex = value;
                });
              },
              title: Text(card['cardNumber']!),
              subtitle: Text(card['cardHolder']!),
              activeColor: Colors.pink.shade400,
            );
          }),

          const SizedBox(height: 16),

          // Adicionar novo cartão
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AdicionarCartaoScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add_card),
            label: const Text('Adicionar novo cartão'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.pink.shade400,
              side: BorderSide(color: Colors.pink.shade400),
            ),
          ),

          const SizedBox(height: 32),

          // Finalizar Pedido
          ElevatedButton(
            onPressed: selectedCardIndex != null
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pedido finalizado com sucesso!'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );

                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CategoriasScreen(),
                        ),
                        (route) => false,
                      );
                    });
                  }
                : null,

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink.shade400,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Finalizar Pedido',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
