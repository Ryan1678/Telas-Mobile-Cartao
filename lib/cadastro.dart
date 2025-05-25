import 'package:flutter/material.dart';
import 'login.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController rmController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String? escolaSelecionada;
  String? anoSelecionado;

  final List<String> escolas = [
    'ITB Brasílio Flores de Azevedo',
    'ITB Prof.ª Maria Sylvia Chaluppe Mello',
    'ITB Professor Moacyr Domingos Savio',
    'ITB Professor Munir José',
  ];

  final List<String> anos = [
    '1º ano do Ensino Médio',
    '2º ano do Ensino Médio',
    '3º ano do Ensino Médio',
  ];

  void handleCadastro() {
    if (!_formKey.currentState!.validate()) return;

    if (escolaSelecionada == null || anoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione a escola e o ano escolar.')),
      );
      return;
    }

    // Lógica de cadastro
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cadastro realizado com sucesso!')),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
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
                      const Text('Nome completo', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextFormField(
                        controller: nomeController,
                        decoration: const InputDecoration(
                          hintText: 'João da Silva',
                          border: UnderlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Informe seu nome completo';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      const Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'email@gmail.com',
                          border: UnderlineInputBorder(),
                        ),
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

                      const Text('RM', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextFormField(
                        controller: rmController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: '123456',
                          border: UnderlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Informe o RM';
                          }
                          if (!RegExp(r'^\d+$').hasMatch(value)) {
                            return 'O RM deve conter apenas números';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      const Text('Escola', style: TextStyle(fontWeight: FontWeight.bold)),
                      DropdownButtonFormField<String>(
                        value: escolaSelecionada,
                        items: escolas
                            .map((escola) => DropdownMenuItem(
                                  value: escola,
                                  child: Text(escola),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            escolaSelecionada = value;
                          });
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: 'Selecione sua escola',
                        ),
                        validator: (value) =>
                            value == null ? 'Selecione uma escola' : null,
                      ),
                      const SizedBox(height: 16),

                      const Text('Ano escolar', style: TextStyle(fontWeight: FontWeight.bold)),
                      DropdownButtonFormField<String>(
                        value: anoSelecionado,
                        items: anos
                            .map((ano) => DropdownMenuItem(
                                  value: ano,
                                  child: Text(ano),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            anoSelecionado = value;
                          });
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: 'Selecione o ano',
                        ),
                        validator: (value) =>
                            value == null ? 'Selecione o ano escolar' : null,
                      ),
                      const SizedBox(height: 16),

                      const Text('Senha', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextFormField(
                        controller: senhaController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: '************',
                          border: UnderlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Informe uma senha';
                          }
                          if (value.length < 6) {
                            return 'A senha deve ter no mínimo 6 caracteres';
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
                        child: const Text('Cadastrar', style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(height: 16),

                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                            );
                          },
                          child: const Text('Já tem uma conta? Fazer login'),
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
