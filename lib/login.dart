import 'package:flutter/material.dart';
import 'cadastro.dart';
import 'esqueceusenha.dart';
import 'Apresentação.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void handleLogin() {
    if (!_formKey.currentState!.validate()) return;

    // Simulação de login bem-sucedido
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login realizado com sucesso!')),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PresentationScreen()),
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
                        onPressed: handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Entrar', style: TextStyle(color: Colors.white)),
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
                          child: const Text('Esqueceu a senha?'),
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
                          child: const Text.rich(
                            TextSpan(
                              text: 'Não possui um login? ',
                              children: [
                                TextSpan(
                                  text: 'Faça cadastro',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
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
