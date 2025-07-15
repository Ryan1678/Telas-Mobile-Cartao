import 'package:flutter/material.dart';

class ConfiguracoesPerfilScreen extends StatefulWidget {
  const ConfiguracoesPerfilScreen({super.key});

  @override
  State<ConfiguracoesPerfilScreen> createState() => _ConfiguracoesPerfilScreenState();
}

class _ConfiguracoesPerfilScreenState extends State<ConfiguracoesPerfilScreen> {
  bool editando = false;
  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController(text: 'João da Silva');
  final nascimentoController = TextEditingController(text: '15/04/2005');
  final rmController = TextEditingController(text: '123456');
  final telefoneController = TextEditingController(text: '(11) 91234-5678');
  final emailController = TextEditingController(text: 'joao@email.com');
  final senhaController = TextEditingController(text: '123456');

  String formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final ano = data.year.toString();
    return '$dia/$mes/$ano';
  }

  DateTime? parseData(String texto) {
    try {
      final partes = texto.split('/');
      if (partes.length != 3) return null;
      final dia = int.parse(partes[0]);
      final mes = int.parse(partes[1]);
      final ano = int.parse(partes[2]);
      return DateTime(ano, mes, dia);
    } catch (_) {
      return null;
    }
  }

  void salvarAlteracoes() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informações atualizadas com sucesso!')),
      );
      setState(() {
        editando = false;
      });
    }
  }

  Future<void> selecionarDataNascimento() async {
    DateTime dataInicial = parseData(nascimentoController.text) ?? DateTime(2005, 1, 1);

    final DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: dataInicial,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Selecione sua data de nascimento',
    );

    if (dataSelecionada != null) {
      nascimentoController.text = formatarData(dataSelecionada);
    }
  }

  Widget _buildCampo({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.grey,
            )),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 6,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: child,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildVisualizacao(String label, String valor) {
    return _buildCampo(
      label: label,
      child: TextFormField(
        initialValue: valor,
        enabled: false,
        readOnly: true,
        style: const TextStyle(fontSize: 16, color: Colors.black),
        decoration: const InputDecoration(
          border: InputBorder.none,
          disabledBorder: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seu Perfil'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.pinkAccent,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: editando ? Colors.grey[300] : Colors.pinkAccent,
        onPressed: () => setState(() => editando = !editando),
        child: Icon(editando ? Icons.close : Icons.edit, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: editando
                      ? [
                          _buildCampo(
                            label: 'Nome completo',
                            child: TextFormField(
                              controller: nomeController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Digite seu nome',
                              ),
                              validator: (value) => value!.trim().isEmpty ? 'Informe seu nome' : null,
                            ),
                          ),
                          _buildCampo(
                            label: 'Data de nascimento',
                            child: TextFormField(
                              controller: nascimentoController,
                              readOnly: true,
                              onTap: selecionarDataNascimento,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              validator: (value) {
                                if (parseData(value ?? '') == null) return 'Data inválida';
                                return null;
                              },
                            ),
                          ),
                          _buildCampo(
                            label: 'RM',
                            child: TextFormField(
                              controller: rmController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(border: InputBorder.none),
                              validator: (value) => value!.isEmpty ? 'Informe seu RM' : null,
                            ),
                          ),
                          _buildCampo(
                            label: 'Telefone',
                            child: TextFormField(
                              controller: telefoneController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: '(11) 91234-5678',
                              ),
                              validator: (value) => value!.isEmpty ? 'Informe seu telefone' : null,
                            ),
                          ),
                          _buildCampo(
                            label: 'E-mail',
                            child: TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'exemplo@email.com',
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) return 'Informe seu e-mail';
                                if (!RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) {
                                  return 'E-mail inválido';
                                }
                                return null;
                              },
                            ),
                          ),
                          _buildCampo(
                            label: 'Senha',
                            child: TextFormField(
                              controller: senhaController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: '••••••',
                              ),
                              validator: (value) => value!.length < 6 ? 'Mínimo 6 caracteres' : null,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: salvarAlteracoes,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pinkAccent,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text('Salvar Alterações',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ]
                      : [
                          _buildVisualizacao('Nome completo', nomeController.text),
                          _buildVisualizacao('Data de nascimento', nascimentoController.text),
                          _buildVisualizacao('RM', rmController.text),
                          _buildVisualizacao('Telefone', telefoneController.text),
                          _buildVisualizacao('E-mail', emailController.text),
                          _buildVisualizacao('Senha', '••••••'),
                        ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
