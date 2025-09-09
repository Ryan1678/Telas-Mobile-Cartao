import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cartao_virtual.dart';
import 'perfil.dart';
import 'login.dart'; // MobileUser

class SolicitarRecargaScreen extends StatefulWidget {
  final MobileUser user;
  const SolicitarRecargaScreen({super.key, required this.user});

  @override
  State<SolicitarRecargaScreen> createState() =>
      _SolicitarRecargaScreenState();
}

class _SolicitarRecargaScreenState extends State<SolicitarRecargaScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String? selectedCardId;
  String valor = '';

  final List<String> cartoesMock = ['001-AB', '002-CD', '003-EF'];

  late final AnimationController _waveAnimationController;

  @override
  void initState() {
    super.initState();
    _waveAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveAnimationController.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    Widget screen;
    switch (index) {
      case 0:
        screen = CartaoVirtualScreen(user: widget.user);
        break;
      case 2:
        screen = PerfilScreen(user: widget.user);
        break;
      default:
        screen = CartaoVirtualScreen(user: widget.user);
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
            'Solicitação de recarga de R\$ $valor enviada para o cartão $selectedCardId.',
          ),
          backgroundColor: Colors.pink.shade400,
        ),
      );

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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8BBD0), Color(0xFFFFE4EC), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.pink.shade400,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  CartaoVirtualScreen(user: widget.user)),
                        );
                      },
                    ),
                    Expanded(
                      child: Text(
                        'Solicitar Recarga',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink.shade400,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        Text(
                          'Escolha um Cartão',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.pink.shade400,
                          ),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                          ),
                          hint: Text('Selecione o ID do cartão',
                              style: GoogleFonts.poppins()),
                          value: selectedCardId,
                          items: cartoesMock.map((id) {
                            return DropdownMenuItem(
                              value: id,
                              child: Text('Cartão $id',
                                  style: GoogleFonts.poppins()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCardId = value;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Selecione um cartão' : null,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Valor da Recarga',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.pink.shade400,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            hintText: 'Digite o valor (ex: 50.00)',
                            hintStyle: GoogleFonts.poppins(
                                color: const Color.fromARGB(255, 110, 110, 110)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16)),
                            prefixText: 'R\$ ',
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
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
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            elevation: 4,
                          ),
                          onPressed: _confirmarRecarga,
                          child: Text(
                            'Solicitar Recarga',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          AnimatedBuilder(
            animation: _waveAnimationController,
            builder: (context, child) {
              return CustomPaint(
                painter: WavePainter(_waveAnimationController.value),
                size: const Size(double.infinity, 100),
              );
            },
          ),
          MyBottomNavigationBar(
            currentIndex: 1,
            onTap: _onTap,
          ),
        ],
      ),
    );
  }
}
