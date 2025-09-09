import 'dart:convert';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class EsquecerSenhaScreen extends StatefulWidget {
  const EsquecerSenhaScreen({super.key});

  @override
  State<EsquecerSenhaScreen> createState() => _EsquecerSenhaScreenState();
}

class _EsquecerSenhaScreenState extends State<EsquecerSenhaScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController codigoController = TextEditingController();
  final TextEditingController novaSenhaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool emailPreenchido = false;
  bool codigoEnviado = false; // Para controlar se o código já foi enviado

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      setState(() {
        emailPreenchido = emailController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    codigoController.dispose();
    novaSenhaController.dispose();
    super.dispose();
  }

  // URLs dinâmicas
  String getRecuperarSenhaUrl() {
    return kIsWeb
        ? "http://localhost:8080/auth/recuperar-senha"
        : "http://10.0.2.2:8080/auth/recuperar-senha";
  }

  String getConfirmarResetUrl() {
    return kIsWeb
        ? "http://localhost:8080/auth/confirmar-reset"
        : "http://10.0.2.2:8080/auth/confirmar-reset";
  }

  // Enviar código
  Future<bool> enviarCodigo(String email) async {
    final url = Uri.parse(getRecuperarSenhaUrl());
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        setState(() {
          codigoEnviado = true;
        });
      }

      return response.statusCode == 200;
    } catch (e) {
      print('Erro ao enviar código: $e');
      return false;
    }
  }

  // Confirmar reset de senha
  Future<bool> confirmarReset(String email, String codigo, String novaSenha) async {
    final url = Uri.parse(getConfirmarResetUrl());
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'codigo': codigo,
          'novaSenha': novaSenha,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Erro ao atualizar senha: $e');
      return false;
    }
  }

  void handleAtualizarSenha() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await confirmarReset(
      emailController.text.trim(),
      codigoController.text.trim(),
      novaSenhaController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Senha atualizada com sucesso!' : 'Erro ao atualizar a senha.',
        ),
        backgroundColor: Colors.pink,
      ),
    );

    if (success) {
      Navigator.pop(context);
    }
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(color: Colors.grey.shade500),
      border: const UnderlineInputBorder(),
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
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
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 40),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            minimumSize: const Size(50, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            alignment: Alignment.centerLeft,
                            foregroundColor: Colors.pinkAccent,
                          ),
                          icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                          label: Text(
                            'Voltar',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('Email'),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: _inputDecoration('email@gmail.com'),
                              style: GoogleFonts.poppins(),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Informe um e-mail';
                                }
                                final emailRegex =
                                    RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
                                if (!emailRegex.hasMatch(value)) {
                                  return 'E-mail inválido';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: emailPreenchido
                                ? () async {
                                    final success =
                                        await enviarCodigo(emailController.text.trim());
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(success
                                            ? 'Código enviado para o e-mail.'
                                            : 'Erro ao enviar código.'),
                                        backgroundColor: Colors.pink,
                                      ),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pinkAccent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              codigoEnviado ? 'Reenviar' : 'Send',
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (codigoEnviado) ...[
                        _buildLabel('Código de verificação'),
                        TextFormField(
                          controller: codigoController,
                          decoration: _inputDecoration('Digite o código enviado por e-mail'),
                          style: GoogleFonts.poppins(),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Digite o código de verificação';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        _buildLabel('Nova Senha'),
                        TextFormField(
                          controller: novaSenhaController,
                          obscureText: true,
                          decoration: _inputDecoration('************'),
                          style: GoogleFonts.poppins(),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Digite uma nova senha';
                            }
                            if (value.length < 6) {
                              return 'A senha deve ter no mínimo 6 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: handleAtualizarSenha,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Atualizar Senha',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
