import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'login.dart'; // MobileUser e LoginScreen

class ConfiguracoesPerfilScreen extends StatefulWidget {
  final MobileUser user;
  const ConfiguracoesPerfilScreen({super.key, required this.user});

  @override
  State<ConfiguracoesPerfilScreen> createState() =>
      _ConfiguracoesPerfilScreenState();
}

class _ConfiguracoesPerfilScreenState extends State<ConfiguracoesPerfilScreen> {
  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final nascimentoController = TextEditingController();
  final tipoClienteController = TextEditingController();
  final documentoController = TextEditingController();
  final telefoneController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  bool carregando = true;

  String get apiBaseUrl {
    if (kIsWeb) {
      return "http://localhost:8080/cadastro"; // Web
    } else {
      return "http://10.0.2.2:8080/cadastro"; // Android emulator
    }
  }

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
  }

  Future<void> _carregarUsuario() async {
    try {
      final response = await http.get(Uri.parse("$apiBaseUrl/${widget.user.id}"));
      if (response.statusCode == 200) {
        final Map<String, dynamic> usuarioData = json.decode(response.body);
        setState(() {
          nomeController.text = usuarioData['usuario']['nome'] ?? '';
          emailController.text = usuarioData['usuario']['email'] ?? '';
          senhaController.text = '******'; // Sempre oculta
          tipoClienteController.text = usuarioData['cliente']['tipoCliente'] ?? '';
          documentoController.text = usuarioData['cliente']['documento'] ?? '';
          telefoneController.text = usuarioData['cliente']['telefone'] ?? '';
          nascimentoController.text = usuarioData['cliente']['dataNascimento'] ?? '';
          carregando = false;
        });
      } else {
        throw Exception("Erro ao carregar usuário");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Falha ao carregar usuário: $e")),
      );
    }
  }

  Future<void> _salvarAlteracoes() async {
    if (!_formKey.currentState!.validate()) return;

    final Map<String, dynamic> dadosAtualizados = {
      "nome": nomeController.text,
      "email": emailController.text,
      "tipoCliente": tipoClienteController.text,
      "documento": documentoController.text,
      "telefone": telefoneController.text,
      "dataNascimento": nascimentoController.text,
    };

    // Atualiza senha apenas se foi digitada nova
    if (senhaController.text != '******') {
      dadosAtualizados["senha"] = senhaController.text;
    }

    try {
      final response = await http.put(
        Uri.parse("$apiBaseUrl/${widget.user.id}"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(dadosAtualizados),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Alterações salvas com sucesso!')),
        );
      } else {
        throw Exception("Erro ao atualizar usuário");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Falha ao atualizar: $e")),
      );
    }
  }

  Future<void> _deletarUsuario() async {
    try {
      final response = await http.delete(
        Uri.parse("$apiBaseUrl/${widget.user.id}"),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conta deletada com sucesso!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        throw Exception("Erro ao deletar usuário");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Falha ao deletar: $e")),
      );
    }
  }

  Widget _buildCampo({
    required String label,
    required TextEditingController controller,
    bool obscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.white70,
            )),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextFormField(
            controller: controller,
            obscureText: obscure,
            style: GoogleFonts.poppins(color: Colors.white),
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade200, Colors.pink.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Configurações do Perfil',
                      style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 30),

                  _buildCampo(label: 'Nome completo', controller: nomeController),
                  _buildCampo(label: 'E-mail', controller: emailController),
                  _buildCampo(label: 'Senha', controller: senhaController, obscure: true),
                  _buildCampo(label: 'Tipo de Cliente', controller: tipoClienteController),
                  _buildCampo(
                      label: tipoClienteController.text == 'Aluno' ? 'RM' : 'CPF',
                      controller: documentoController),
                  _buildCampo(label: 'Telefone', controller: telefoneController),
                  _buildCampo(label: 'Data de nascimento', controller: nascimentoController),

                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _salvarAlteracoes,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pinkAccent,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                          child: Text('Salvar Alterações',
                              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _deletarUsuario,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                          child: Text('Deletar Conta',
                              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
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
