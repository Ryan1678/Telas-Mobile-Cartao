import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class FaleConoscoScreen extends StatefulWidget {
  const FaleConoscoScreen({super.key});

  @override
  State<FaleConoscoScreen> createState() => _FaleConoscoScreenState();
}

class _FaleConoscoScreenState extends State<FaleConoscoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _telefoneController = TextEditingController();
  final _tituloController = TextEditingController();
  final _mensagemController = TextEditingController();

  // Detecta a plataforma e retorna a URL correta
  String getBackendUrl() {
    if (kIsWeb) {
      // Flutter Web
      return "http://localhost:8080/mensagens";
    } else {
      // Android Emulator
      return "http://10.0.2.2:8080/mensagens";
      // Se for iOS Simulator, use "http://localhost:8080/mensagens"
    }
  }

  Future<void> _enviarFormulario() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse(getBackendUrl());

      final body = jsonEncode({
        "telefone": _telefoneController.text,
        "titulo": _tituloController.text,
        "texto": _mensagemController.text,
      });

      try {
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Mensagem enviada com sucesso!"),
              backgroundColor: Colors.pink,
            ),
          );
          _telefoneController.clear();
          _tituloController.clear();
          _mensagemController.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Erro ao enviar: ${response.statusCode}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Falha na conexão: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _telefoneController.dispose();
    _tituloController.dispose();
    _mensagemController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.pink.shade600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Fale Conosco',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.pink.shade600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.pink.shade600),
      ),
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
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildLabel('Telefone'),
                  TextFormField(
                    controller: _telefoneController,
                    keyboardType: TextInputType.phone,
                    decoration: _inputDecoration('(00) 00000-0000'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, informe seu telefone.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildLabel('Título do Assunto'),
                  TextFormField(
                    controller: _tituloController,
                    decoration: _inputDecoration('Digite o título'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, informe o título do assunto.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildLabel('Mensagem'),
                  TextFormField(
                    controller: _mensagemController,
                    maxLines: 5,
                    decoration: _inputDecoration('Descreva sua dúvida ou sugestão'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, escreva sua mensagem.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _enviarFormulario,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade500,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      'Enviar',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
