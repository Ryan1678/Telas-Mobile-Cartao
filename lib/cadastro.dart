import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'login.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final dataNascimentoController = TextEditingController();
  final documentoController = TextEditingController();
  final telefoneController = TextEditingController();

  String tipoCliente = 'Aluno';
  bool _obscureSenha = true;

  // Detecta a plataforma e retorna a URL correta
  String getBackendUrl() {
    if (kIsWeb) {
      return "http://localhost:8080/cadastro";
    } else {
      return "http://10.0.2.2:8080/cadastro";
    }
  }

  Future<void> handleCadastro() async {
    if (!_formKey.currentState!.validate()) return;

    // Converte data dd/MM/yyyy para yyyy-MM-dd
    final parts = dataNascimentoController.text.split('/');
    final dataFormatada = "${parts[2]}-${parts[1]}-${parts[0]}";

    final url = Uri.parse(getBackendUrl());
    final body = jsonEncode({
      "nome": nomeController.text.trim(),
      "email": emailController.text.trim(),
      "senha": senhaController.text.trim(),
      "dataNascimento": dataFormatada,
      "tipoCliente": tipoCliente.toUpperCase(),
      "documento": documentoController.text.trim(),
      "telefone": telefoneController.text.trim(),
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Cadastro realizado com sucesso!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro no cadastro: ${response.body}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Falha na conexão: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2005, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dataNascimentoController.text =
            "${picked.day.toString().padLeft(2, '0')}/"
            "${picked.month.toString().padLeft(2, '0')}/"
            "${picked.year}";
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
                      _buildLabel('Nome completo'),
                      TextFormField(
                        controller: nomeController,
                        decoration: _inputDecoration('João da Silva'),
                        style: GoogleFonts.poppins(),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Informe seu nome completo'
                                : null,
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('E-mail'),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration('exemplo@email.com'),
                        style: GoogleFonts.poppins(),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Informe seu e-mail';
                          }
                          if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,4}$')
                              .hasMatch(value)) {
                            return 'E-mail inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('Senha'),
                      TextFormField(
                        controller: senhaController,
                        obscureText: _obscureSenha,
                        decoration: InputDecoration(
                          hintText: 'Digite sua senha',
                          border: const UnderlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureSenha
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() => _obscureSenha = !_obscureSenha);
                            },
                          ),
                        ),
                        style: GoogleFonts.poppins(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe sua senha';
                          }
                          if (value.length < 6) {
                            return 'A senha deve ter no mínimo 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('Data de nascimento'),
                      TextFormField(
                        controller: dataNascimentoController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'DD/MM/AAAA',
                          border: const UnderlineInputBorder(),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        style: GoogleFonts.poppins(),
                        onTap: () => _selectDate(context),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Informe a data de nascimento'
                                : null,
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('Tipo de Cliente'),
                      DropdownButtonFormField<String>(
                        value: tipoCliente,
                        items: ['Aluno', 'Responsável', 'Professor']
                            .map((tipo) => DropdownMenuItem(
                                  value: tipo,
                                  child: Text(tipo, style: GoogleFonts.poppins()),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            tipoCliente = value!;
                            documentoController.clear();
                          });
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('Documento'),
                      TextFormField(
                        controller: documentoController,
                        keyboardType: TextInputType.text,
                        style: GoogleFonts.poppins(),
                        decoration: _inputDecoration(
                            tipoCliente == 'Aluno' ? 'RM' : 'CPF'),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Informe o documento'
                                : null,
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('Telefone'),
                      TextFormField(
                        controller: telefoneController,
                        keyboardType: TextInputType.phone,
                        style: GoogleFonts.poppins(),
                        decoration: _inputDecoration('(99) 99999-9999'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Informe o telefone';
                          }
                          if (!RegExp(r'^\(?\d{2}\)? ?\d{4,5}-?\d{4}$')
                              .hasMatch(value)) {
                            return 'Telefone inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: handleCadastro,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Cadastrar',
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                          child: Text(
                            'Já tem uma conta? Fazer login',
                            style: GoogleFonts.poppins(
                              color: Colors.pink.shade600,
                              fontWeight: FontWeight.w500,
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
