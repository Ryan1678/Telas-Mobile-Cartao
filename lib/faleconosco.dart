import 'package:flutter/material.dart';

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

  void _enviarFormulario() {
    if (_formKey.currentState!.validate()) {
      // Aqui você pode integrar com backend, API ou exibir uma mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mensagem enviada com sucesso!')),
      );

      // Limpar os campos após o envio
      _telefoneController.clear();
      _tituloController.clear();
      _mensagemController.clear();
    }
  }

  @override
  void dispose() {
    _telefoneController.dispose();
    _tituloController.dispose();
    _mensagemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fale Conosco',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.pink),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Telefone',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _telefoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '(00) 00000-0000',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe seu telefone.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              const Text(
                'Título do Assunto',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Digite o título',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe o título do assunto.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              const Text(
                'Mensagem',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _mensagemController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Descreva sua dúvida ou sugestão',
                ),
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
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Enviar',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
