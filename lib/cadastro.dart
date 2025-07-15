import 'package:flutter/material.dart';
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
  final rmController = TextEditingController();
  final telefoneController = TextEditingController();

  bool _obscureSenha = true;

  void handleCadastro() {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cadastro realizado com sucesso!')),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
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
        dataNascimentoController.text = "${picked.day.toString().padLeft(2, '0')}/"
            "${picked.month.toString().padLeft(2, '0')}/"
            "${picked.year}";
      });
    }
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

                      const Text('E-mail', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'exemplo@email.com',
                          border: UnderlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Informe seu e-mail';
                          }
                          if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,4}$').hasMatch(value)) {
                            return 'E-mail inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      const Text('Senha', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextFormField(
                        controller: senhaController,
                        obscureText: _obscureSenha,
                        decoration: InputDecoration(
                          hintText: 'Digite sua senha',
                          border: const UnderlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureSenha ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              setState(() => _obscureSenha = !_obscureSenha);
                            },
                          ),
                        ),
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

                      const Text('Data de nascimento', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextFormField(
                        controller: dataNascimentoController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          hintText: 'DD/MM/AAAA',
                          border: UnderlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: () => _selectDate(context),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Informe a data de nascimento';
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

                      const Text('Telefone', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextFormField(
                        controller: telefoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: '(99) 99999-9999',
                          border: UnderlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Informe o telefone';
                          }
                          if (!RegExp(r'^\(?\d{2}\)? ?\d{4,5}-?\d{4}$').hasMatch(value)) {
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
