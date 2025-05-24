import 'package:flutter/material.dart';

class ProdutoDoce {
  final String nome;
  final String descricao;
  final double preco;
  final String imagem;

  ProdutoDoce({
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.imagem,
  });
}

class DocesScreen extends StatefulWidget {
  const DocesScreen({super.key});

  @override
  State<DocesScreen> createState() => _DocesScreenState();
}

class _DocesScreenState extends State<DocesScreen> {
  final List<ProdutoDoce> doces = [
    ProdutoDoce(
      nome: 'Brigadeiro',
      descricao: 'Brigadeiro gourmet delicioso',
      preco: 3.0,
      imagem: 'assets/images/brigadeiro.jpg',
    ),
    ProdutoDoce(
      nome: 'Beijinho',
      descricao: 'Beijinho cremoso',
      preco: 3.0,
      imagem: 'assets/images/beijinho.jpg',
    ),
    ProdutoDoce(
      nome: 'Quindim',
      descricao: 'Quindim tradicional',
      preco: 4.0,
      imagem: 'assets/images/quindim.jpg',
    ),
  ];

  final Map<int, int> quantidades = {};

  void incrementar(int index) {
    setState(() {
      quantidades[index] = (quantidades[index] ?? 0) + 1;
    });
  }

  void decrementar(int index) {
    setState(() {
      if ((quantidades[index] ?? 0) > 0) {
        quantidades[index] = quantidades[index]! - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doces'),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: doces.length,
        itemBuilder: (context, index) {
          final produto = doces[index];
          final quantidade = quantidades[index] ?? 0;

          return LayoutBuilder(
            builder: (context, constraints) {
              final imageSize = constraints.maxWidth * 0.25;
              final imageDimension = imageSize.clamp(80.0, 120.0);

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: imageDimension,
                          height: imageDimension,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              produto.imagem,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                produto.nome,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                produto.descricao,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'R\$ ${produto.preco.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.pinkAccent.shade400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline,
                              color: Colors.pinkAccent),
                          onPressed: () => decrementar(index),
                        ),
                        Text(
                          '$quantidade',
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline,
                              color: Colors.pinkAccent),
                          onPressed: () => incrementar(index),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: quantidade > 0
                              ? () {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        '$quantidade ${produto.nome}(s) adicionados ao carrinho!'),
                                    duration: const Duration(seconds: 2),
                                  ));
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Adicionar'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
