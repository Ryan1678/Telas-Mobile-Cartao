import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'cadastro.dart';
import 'esqueceusenha.dart';
import 'Apresentação.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;

  // Detecta plataforma e retorna URL correta
  String getBackendUrl() {
    if (kIsWeb) {
      return "http://localhost:8080/api/mobile/login";
    } else {
      return "http://10.0.2.2:8080/api/mobile/login";
    }
  }

  Future<void> handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
    });

    final url = Uri.parse(getBackendUrl());
    final payload = {
      "email": emailController.text.trim(),
      "senha": senhaController.text.trim(),
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      // Decodifica o JSON do backend
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Login válido
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login realizado com sucesso!'),
            backgroundColor: Colors.pink,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PresentationScreen()),
        );
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        // Erro: credenciais inválidas ou acesso negado
        final errorMsg = data['error'] ?? 'Erro ao realizar login.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        // Outros erros inesperados
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro inesperado: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Erro de conexão
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao conectar com o servidor: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _loading = false;
      });
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
                      _buildLabel('Email'),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration('email@gmail.com'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Informe um e-mail';
                          }
                          final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'E-mail inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('Senha'),
                      TextFormField(
                        controller: senhaController,
                        obscureText: true,
                        decoration: _inputDecoration('************'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Informe sua senha';
                          }
                          if (value.length < 6) {
                            return 'A senha deve ter no mínimo 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _loading ? null : handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent.shade200,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: _loading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Entrar',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const EsquecerSenhaScreen()),
                            );
                          },
                          child: Text(
                            'Esqueceu a senha?',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.pink.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const CadastroScreen()),
                            );
                          },
                          child: Text.rich(
                            TextSpan(
                              text: 'Não possui um login? ',
                              style: GoogleFonts.poppins(color: Colors.grey.shade700),
                              children: [
                                TextSpan(
                                  text: 'Faça cadastro',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink.shade600,
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
            ),
          ),
        ],
      ),
    );
  }
}
