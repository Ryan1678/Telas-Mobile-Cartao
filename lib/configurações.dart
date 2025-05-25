import 'package:flutter/material.dart';

class ConfiguracoesPerfilScreen extends StatefulWidget {
  const ConfiguracoesPerfilScreen({super.key});

  @override
  State<ConfiguracoesPerfilScreen> createState() => _ConfiguracoesPerfilScreenState();
}

class _ConfiguracoesPerfilScreenState extends State<ConfiguracoesPerfilScreen> {
  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController(text: 'João da Silva');
  final emailController = TextEditingController(text: 'joao@gmail.com');
  final rmController = TextEditingController(text: '123456');
  final senhaController = TextEditingController(text: '********');

  String? escolaSelecionada = 'ITB Brasílio Flores de Azevedo';
  String? anoSelecionado = '2º ano do Ensino Médio';

  final escolas = [
    'ITB Brasílio Flores de Azevedo',
    'ITB Prof.ª Maria Sylvia Chaluppe Mello',
    'ITB Professor Moacyr Domingos Savio',
    'ITB Professor Munir José',
  ];

  final anos = [
    '1º ano do Ensino Médio',
    '2º ano do Ensino Médio',
    '3º ano do Ensino Médio',
  ];

  bool emailValido(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  void salvarAlteracoes() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informações atualizadas com sucesso!')),
      );
    }
  }

  Widget _buildCampo(String label, Widget field) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            field,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Configurações do Perfil'),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.pink.shade400),
        titleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildCampo(
                'Nome completo',
                TextFormField(
                  controller: nomeController,
                  decoration: const InputDecoration(border: UnderlineInputBorder()),
                  validator: (value) => value!.isEmpty ? 'Informe seu nome' : null,
                ),
              ),
              _buildCampo(
                'Email',
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(border: UnderlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Informe seu e-mail';
                    if (!emailValido(value)) return 'Digite um e-mail válido';
                    return null;
                  },
                ),
              ),
              _buildCampo(
                'RM',
                TextFormField(
                  controller: rmController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(border: UnderlineInputBorder()),
                  validator: (value) => value!.isEmpty ? 'Informe seu RM' : null,
                ),
              ),
              _buildCampo(
                'Escola',
                DropdownButtonFormField<String>(
                  value: escolaSelecionada,
                  items: escolas.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (value) => setState(() => escolaSelecionada = value),
                  decoration: const InputDecoration(border: UnderlineInputBorder()),
                  validator: (value) => value == null ? 'Selecione uma escola' : null,
                ),
              ),
              _buildCampo(
                'Ano Escolar',
                DropdownButtonFormField<String>(
                  value: anoSelecionado,
                  items: anos.map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
                  onChanged: (value) => setState(() => anoSelecionado = value),
                  decoration: const InputDecoration(border: UnderlineInputBorder()),
                  validator: (value) => value == null ? 'Selecione um ano escolar' : null,
                ),
              ),
              _buildCampo(
                'Senha',
                TextFormField(
                  controller: senhaController,
                  obscureText: true,
                  decoration: const InputDecoration(border: UnderlineInputBorder()),
                  validator: (value) => value!.length < 6 ? 'Mínimo de 6 caracteres' : null,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: salvarAlteracoes,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Salvar Alterações', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
