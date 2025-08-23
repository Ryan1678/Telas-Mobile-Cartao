import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CarteiraScreen extends StatefulWidget {
  const CarteiraScreen({super.key});

  @override
  State<CarteiraScreen> createState() => _CarteiraScreenState();
}

class _CarteiraScreenState extends State<CarteiraScreen> with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> cartoes = [
    {
      'nome': 'João da Silva',
      'numero': '**** **** **** 1234',
      'id': '001-AB',
      'data': DateTime.now(),
      'saldo': '150.00',
    },
    {
      'nome': 'Maria Oliveira',
      'numero': '**** **** **** 5678',
      'id': '002-CD',
      'data': DateTime.now(),
      'saldo': '250.00',
    },
  ];

  late AnimationController animController;
  late Animation<Offset> animation;

  @override
  void initState() {
    super.initState();
    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    animation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: animController, curve: Curves.easeOut),
    );
    animController.forward();
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  void _editarNome(int index) {
    final controller = TextEditingController(text: cartoes[index]['nome']);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Editar Nome', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink.shade500,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              setState(() {
                cartoes[index]['nome'] = controller.text;
              });
              Navigator.pop(context);
            },
            child: Text('Salvar', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deletarCartao(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Excluir Cartão', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text('Deseja realmente excluir este cartão?', style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              setState(() {
                cartoes.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text('Deletar', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildCartao(int index) {
    final cartao = cartoes[index];
    return FadeTransition(
      opacity: animController,
      child: SlideTransition(
        position: animation,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink.shade300, Colors.pink.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.pink.shade100.withOpacity(0.5),
                blurRadius: 6,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartao['numero'],
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Nome: ${cartao['nome']}',
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                ),
                Text(
                  'ID: ${cartao['id']}',
                  style: GoogleFonts.poppins(color: Colors.white70),
                ),
                Text(
                  'Criado em: ${cartao['data'].toString().substring(0, 16)}',
                  style: GoogleFonts.poppins(color: Colors.white70),
                ),
                Text(
                  'Saldo: R\$ ${cartao['saldo']}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _editarNome(index),
                      icon: const Icon(Icons.edit, size: 18, color: Colors.white),
                      label: Text('Editar', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink.shade500,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _deletarCartao(index),
                      icon: const Icon(Icons.delete, size: 18, color: Colors.white),
                      label: Text('Deletar', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Minha Carteira',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.pink.shade600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.pink.shade400),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8BBD0), Color(0xFFFFE4EC), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: cartoes.isEmpty
                ? Center(
                    child: Text(
                      'Nenhum cartão disponível.',
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey.shade700),
                    ),
                  )
                : ListView.builder(
                    itemCount: cartoes.length,
                    itemBuilder: (context, index) => _buildCartao(index),
                  ),
          ),
        ),
      ),
    );
  }
}
