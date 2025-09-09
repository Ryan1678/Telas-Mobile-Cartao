import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'login.dart'; // Onde está MobileUser

class CarteiraScreen extends StatefulWidget {
  final MobileUser user; // Recebe o usuário logado
  const CarteiraScreen({super.key, required this.user});

  @override
  State<CarteiraScreen> createState() => _CarteiraScreenState();
}

class _CarteiraScreenState extends State<CarteiraScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> cartoes = [];

  late AnimationController animController;
  late Animation<Offset> animation;

  @override
  void initState() {
    super.initState();
    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    animation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
      CurvedAnimation(parent: animController, curve: Curves.easeOut),
    );
    _carregarCartoes();
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  // URL do backend (kIsWeb para Web, 10.0.2.2 para emulador Android)
  String getBackendUrl() {
    if (kIsWeb) {
      return "http://localhost:8080/api/cartao";
    } else {
      return "http://10.0.2.2:8080/api/cartao";
    }
  }

  // Carregar cartões do usuário
  Future<void> _carregarCartoes() async {
    try {
      final url = Uri.parse("${getBackendUrl()}/${widget.user.id}");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          cartoes = data.map((c) => {
                'id': c['id'],
                'nome': c['nome'],
                'numero': c['numero'],
                'saldo': c['saldo'],
                'data': DateTime.parse(c['dataCadastro']),
              }).toList();
          animController.forward(from: 0);
        });
      } else {
        debugPrint("Erro ao carregar cartões: ${response.body}");
      }
    } catch (e) {
      debugPrint("Erro ao carregar cartões: $e");
    }
  }

  // Editar nome do cartão
  Future<void> _editarNome(int index) async {
    final controller = TextEditingController(text: cartoes[index]['nome']);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Editar Nome',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
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
            onPressed: () async {
              final novoNome = controller.text.trim();
              if (novoNome.isEmpty) return;

              final url = Uri.parse("${getBackendUrl()}/${cartoes[index]['id']}");
              final response = await http.put(
                url,
                headers: {"Content-Type": "application/json"},
                body: jsonEncode({"nome": novoNome}),
              );

              if (response.statusCode == 200) {
                setState(() {
                  cartoes[index]['nome'] = novoNome;
                });
                Navigator.pop(context);
              } else {
                debugPrint("Erro ao atualizar nome: ${response.body}");
              }
            },
            child: Text('Salvar', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Deletar cartão
  Future<void> _deletarCartao(int index) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Excluir Cartão',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text('Deseja realmente excluir este cartão?',
            style: GoogleFonts.poppins()),
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
            onPressed: () async {
              final url = Uri.parse("${getBackendUrl()}/${cartoes[index]['id']}");
              final response = await http.delete(url);

              if (response.statusCode == 204) {
                setState(() {
                  cartoes.removeAt(index);
                });
                Navigator.pop(context);
              } else {
                debugPrint("Erro ao deletar cartão: ${response.body}");
              }
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
                  '**** **** **** ${cartao['numero'].substring(12)}',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Nome: ${cartao['nome']}', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                Text('Saldo: R\$ ${cartao['saldo'].toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
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
        title: Text('Minha Carteira', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.pink.shade600)),
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
