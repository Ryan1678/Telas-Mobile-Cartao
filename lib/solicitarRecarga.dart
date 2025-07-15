import 'package:flutter/material.dart';
import 'cartao_virtual.dart';
import 'perfil.dart';

class SolicitarRecargaScreen extends StatefulWidget {
  const SolicitarRecargaScreen({super.key});

  @override
  State<SolicitarRecargaScreen> createState() => _SolicitarRecargaScreenState();
}

class _SolicitarRecargaScreenState extends State<SolicitarRecargaScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedCardId;
  String valor = '';

  final List<String> cartoesMock = ['001-AB', '002-CD', '003-EF']; // Mock dos cartões

  void _onTap(int index) {
    Widget screen;
    switch (index) {
      case 0:
        screen = const CartaoVirtualScreen();
        break;
      case 2:
        screen = const PerfilScreen();
        break;
      default:
        screen = const CartaoVirtualScreen();
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  void _confirmarRecarga() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Solicitação de recarga de R\$ $valor enviada para o cartão $selectedCardId. Aguarde a confirmação do admin.',
          ),
          backgroundColor: Colors.green,
        ),
      );
      // Aqui pode chamar API ou salvar no banco

      // Resetar o form
      setState(() {
        selectedCardId = null;
        valor = '';
        _formKey.currentState!.reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Solicitar Recarga',
          style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
        ),
         backgroundColor: Colors.white,
  elevation: 0,
  iconTheme: IconThemeData(color: Colors.pink.shade400),
  leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CartaoVirtualScreen()),
      );
    },
  ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Escolha um Cartão',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                hint: const Text('Selecione o ID do cartão'),
                value: selectedCardId,
                items: cartoesMock.map((id) {
                  return DropdownMenuItem(value: id, child: Text('Cartão $id'));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCardId = value;
                  });
                },
                validator: (value) => value == null ? 'Selecione um cartão' : null,
              ),
              const SizedBox(height: 24),
              const Text(
                'Valor da Recarga',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: 'Digite o valor (ex: 50.00)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixText: 'R\$ ',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe um valor';
                  final double? v = double.tryParse(value.replaceAll(',', '.'));
                  if (v == null || v <= 0) return 'Valor inválido';
                  return null;
                },
                onChanged: (value) => valor = value,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade400,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _confirmarRecarga,
                child: const Text(
                  'Solicitar Recarga',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 1, // índice correto para esta tela (ajuste conforme seu BottomNav)
        onTap: _onTap,
      ),
    );
  }
}
