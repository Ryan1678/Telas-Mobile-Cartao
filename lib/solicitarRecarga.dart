import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'cartao_virtual.dart';
import 'perfil.dart';
import 'login.dart'; // MobileUser

// Modelo de cartão
class Cartao {
  final int id;
  final String numero;

  Cartao({required this.id, required this.numero});

  factory Cartao.fromJson(Map<String, dynamic> json) {
    return Cartao(
      id: json['id'],
      numero: json['numero'],
    );
  }
}

class SolicitarRecargaScreen extends StatefulWidget {
  final MobileUser user;
  const SolicitarRecargaScreen({super.key, required this.user});

  @override
  State<SolicitarRecargaScreen> createState() =>
      _SolicitarRecargaScreenState();
}

class _SolicitarRecargaScreenState extends State<SolicitarRecargaScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String? selectedCardId;
  String valor = '';

  late final AnimationController _waveAnimationController;

  late final String baseUrlUsuarios;
  late final String baseUrlSolicitacoes;

  List<Cartao> cartoes = [];

  @override
  void initState() {
    super.initState();

    // Inicializa URLs
    if (kIsWeb) {
      baseUrlUsuarios = "http://localhost:8080/usuarios";
      baseUrlSolicitacoes = "http://localhost:8080/solicitacoes";
    } else {
      baseUrlUsuarios = "http://10.0.2.2:8080/usuarios";
      baseUrlSolicitacoes = "http://10.0.2.2:8080/solicitacoes";
    }

    _carregarCartoes();

    _waveAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveAnimationController.dispose();
    super.dispose();
  }

  // Carregar cartões do usuário
  Future<void> _carregarCartoes() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrlUsuarios/${widget.user.id}/cartoes"),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          cartoes = data.map((e) => Cartao.fromJson(e)).toList();
        });
      } else {
        print("Erro ao carregar cartões: ${response.body}");
      }
    } catch (e) {
      print("Falha ao conectar: $e");
    }
  }

  void _onTap(int index) {
    Widget screen;
    switch (index) {
      case 0:
        screen = CartaoVirtualScreen(user: widget.user);
        break;
      case 2:
        screen = PerfilScreen(user: widget.user);
        break;
      default:
        screen = CartaoVirtualScreen(user: widget.user);
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  Future<void> _confirmarRecarga() async {
    if (_formKey.currentState!.validate()) {
      final body = {
        "cartao": {"id": int.parse(selectedCardId!)},
        "valor": double.parse(valor.replaceAll(',', '.')),
      };

      try {
        final response = await http.post(
          Uri.parse(baseUrlSolicitacoes),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Solicitação enviada com sucesso!")),
          );
          setState(() {
            selectedCardId = null;
            valor = '';
            _formKey.currentState!.reset();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erro: ${response.body}")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Falha de conexão: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8BBD0), Color(0xFFFFE4EC), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.pink.shade400,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  CartaoVirtualScreen(user: widget.user)),
                        );
                      },
                    ),
                    Expanded(
                      child: Text(
                        'Solicitar Recarga',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink.shade400,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        Text(
                          'Escolha um Cartão',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.pink.shade400,
                          ),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<int>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                          ),
                          hint: Text('Selecione o cartão',
                              style: GoogleFonts.poppins()),
                          value: selectedCardId == null
                              ? null
                              : int.tryParse(selectedCardId!),
                          items: cartoes.map((cartao) {
                            return DropdownMenuItem(
                              value: cartao.id,
                              child: Text("Cartão ${cartao.numero}",
                                  style: GoogleFonts.poppins()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCardId = value.toString();
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Selecione um cartão' : null,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Valor da Recarga',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.pink.shade400,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: InputDecoration(
                            hintText: 'Digite o valor (ex: 50.00)',
                            hintStyle: GoogleFonts.poppins(
                                color: Color.fromARGB(255, 110, 110, 110)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16)),
                            prefixText: 'R\$ ',
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Informe um valor';
                            }
                            final double? v =
                                double.tryParse(value.replaceAll(',', '.'));
                            if (v == null || v <= 0) return 'Valor inválido';
                            return null;
                          },
                          onChanged: (value) => valor = value,
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink.shade400,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            elevation: 4,
                          ),
                          onPressed: _confirmarRecarga,
                          child: Text(
                            'Solicitar Recarga',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
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
            currentIndex: 1,
            onTap: _onTap,
          ),
        ],
      ),
    );
  }
}
