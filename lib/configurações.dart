import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfiguracoesPerfilScreen extends StatefulWidget {
  const ConfiguracoesPerfilScreen({super.key});

  @override
  State<ConfiguracoesPerfilScreen> createState() =>
      _ConfiguracoesPerfilScreenState();
}

class _ConfiguracoesPerfilScreenState extends State<ConfiguracoesPerfilScreen> {
  bool editando = false;
  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController(text: 'João da Silva');
  final nascimentoController = TextEditingController(text: '15/04/2005');
  final tipoClienteController = TextEditingController(text: 'Aluno');
  final documentoController = TextEditingController(text: '123456'); // URM ou CPF
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
    DateTime dataInicial =
        parseData(nascimentoController.text) ?? DateTime(2005, 1, 1);

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
        style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
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
     // Fundo gradiente
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
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                children: [
                  // Botão voltar
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Configurações do Perfil',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: editando
                          ? [
                              _buildCampo(
                                label: 'Nome completo',
                                child: TextFormField(
                                  controller: nomeController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Digite seu nome',
                                    hintStyle: GoogleFonts.poppins(
                                        color: Colors.white70),
                                  ),
                                  style: GoogleFonts.poppins(color: Colors.white),
                                  validator: (value) =>
                                      value!.trim().isEmpty ? 'Informe seu nome' : null,
                                ),
                              ),
                              _buildCampo(
                                label: 'E-mail',
                                child: TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'exemplo@email.com',
                                    hintStyle: GoogleFonts.poppins(
                                        color: Colors.white70),
                                  ),
                                  style: GoogleFonts.poppins(color: Colors.white),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Informe seu e-mail';
                                    }
                                    if (!RegExp(
                                            r'^[\w\-.]+@([\w-]+\.)+[\w]{2,4}$')
                                        .hasMatch(value)) {
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
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '••••••',
                                    hintStyle:
                                        GoogleFonts.poppins(color: Colors.white70),
                                  ),
                                  style: GoogleFonts.poppins(color: Colors.white),
                                  validator: (value) => value!.length < 6
                                      ? 'Mínimo 6 caracteres'
                                      : null,
                                ),
                              ),
                              _buildCampo(
                                label: 'Data de nascimento',
                                child: TextFormField(
                                  controller: nascimentoController,
                                  readOnly: true,
                                  onTap: selecionarDataNascimento,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    suffixIcon: const Icon(Icons.calendar_today,
                                        color: Colors.white),
                                  ),
                                  style: GoogleFonts.poppins(color: Colors.white),
                                  validator: (value) {
                                    if (parseData(value ?? '') == null) {
                                      return 'Data inválida';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              _buildCampo(
                                label: 'Tipo de Cliente',
                                child: DropdownButtonFormField<String>(
                                  value: tipoClienteController.text,
                                  items: const [
                                    DropdownMenuItem(
                                        value: 'Aluno', child: Text('Aluno')),
                                    DropdownMenuItem(
                                        value: 'Responsável',
                                        child: Text('Responsável')),
                                    DropdownMenuItem(
                                        value: 'Professor',
                                        child: Text('Professor')),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      tipoClienteController.text = value ?? 'Aluno';
                                      documentoController.text =
                                          (tipoClienteController.text == 'Aluno')
                                              ? '123456'
                                              : '00000000000';
                                    });
                                  },
                                  decoration: const InputDecoration(border: InputBorder.none),
                                  style: GoogleFonts.poppins(color: Colors.white),
                                  dropdownColor: Colors.pink.shade300,
                                ),
                              ),
                              _buildCampo(
                                label: tipoClienteController.text == 'Aluno'
                                    ? 'RM'
                                    : 'CPF',
                                child: TextFormField(
                                  controller: documentoController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: tipoClienteController.text == 'Aluno'
                                        ? 'Digite seu RM'
                                        : 'Digite seu CPF',
                                    hintStyle: GoogleFonts.poppins(color: Colors.white70),
                                  ),
                                  style: GoogleFonts.poppins(color: Colors.white),
                                  validator: (value) =>
                                      value!.isEmpty ? 'Informe o documento' : null,
                                ),
                              ),
                              _buildCampo(
                                label: 'Telefone',
                                child: TextFormField(
                                  controller: telefoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '(11) 91234-5678',
                                    hintStyle: GoogleFonts.poppins(color: Colors.white70),
                                  ),
                                  style: GoogleFonts.poppins(color: Colors.white),
                                  validator: (value) =>
                                      value!.isEmpty ? 'Informe seu telefone' : null,
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
                                  child: Text('Salvar Alterações',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ]
                          : [
                              _buildVisualizacao('Nome completo', nomeController.text),
                              _buildVisualizacao('E-mail', emailController.text),
                              _buildVisualizacao('Senha', '••••••'),
                              _buildVisualizacao('Data de nascimento', nascimentoController.text),
                              _buildVisualizacao('Tipo de cliente', tipoClienteController.text),
                              _buildVisualizacao(
                                  tipoClienteController.text == 'Aluno' ? 'RM' : 'CPF',
                                  documentoController.text),
                              _buildVisualizacao('Telefone', telefoneController.text),
                            ],
                    ),
                  ),
                  const SizedBox(height: 40),
                                    // Botão flutuante de edição no canto inferior direito
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: FloatingActionButton(
                        backgroundColor: editando ? Colors.grey[300] : Colors.pinkAccent,
                        onPressed: () => setState(() => editando = !editando),
                        child: Icon(editando ? Icons.close : Icons.edit,
                            color: Colors.white),
                      ),
                    ),
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

                 
