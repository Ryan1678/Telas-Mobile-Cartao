import 'package:flutter/material.dart';

class ProdutoSorvete {
  final String nome;
  final String descricao;
  final double preco;
  final String imagem;

  ProdutoSorvete({
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.imagem,
  });
}

class SorvetesScreen extends StatefulWidget {
  const SorvetesScreen({super.key});

  @override
  State<SorvetesScreen> createState() => _SorvetesScreenState();
}

class _SorvetesScreenState extends State<SorvetesScreen> {
  final List<ProdutoSorvete> sorvetes = [
    ProdutoSorvete(
      nome: 'Sorvete de Morango',
      descricao: 'Sorvete cremoso sabor morango',
      preco: 7.0,
      imagem: 'assets/images/sorvete_morango.jpg',
    ),
    ProdutoSorvete(
      nome: 'Sorvete de Chocolate',
      descricao: 'Sorvete sabor chocolate intenso',
      preco: 7.5,
      imagem: 'assets/images/sorvete_chocolate.jpg',
    ),
    ProdutoSorvete(
      nome: 'Picolé de Limão',
      descricao: 'Picolé refrescante sabor limão',
      preco: 5.0,
      imagem: 'assets/images/picole_limao.jpg',
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
        title: const Text('Sorvetes'),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sorvetes.length,
        itemBuilder: (context, index) {
          final produto = sorvetes[index];
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
