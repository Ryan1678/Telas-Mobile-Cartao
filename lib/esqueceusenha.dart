import 'package:flutter/material.dart';

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

  void handleAtualizarSenha() {
    if (!_formKey.currentState!.validate()) return;

    // Aqui viria a lógica real para atualizar a senha após validação
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Senha atualizada com sucesso!')),
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
                          label: const Text('Voltar', style: TextStyle(fontWeight: FontWeight.w500)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      const Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
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
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: emailPreenchido
                                ? () {
                                    // Lógica futura: enviar código de verificação
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Código enviado para o e-mail.')),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pinkAccent,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text('Send', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      const Text('Código de verificação', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextFormField(
                        controller: codigoController,
                        decoration: const InputDecoration(
                          hintText: 'Digite o código enviado por e-mail',
                          border: UnderlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Digite o código de verificação';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),
                      const Text('Nova Senha', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextFormField(
                        controller: novaSenhaController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: '************',
                          border: UnderlineInputBorder(),
                        ),
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
                        child: const Text('Atualizar Senha', style: TextStyle(color: Colors.white)),
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
