import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cartao_virtual.dart';
import 'solicitarRecarga.dart';
import 'configurações.dart';
import 'carteira.dart';
import 'termos_uso.dart';
import 'faleconosco.dart';
import 'main.dart';
import 'login.dart'; // Onde está MobileUser

class PerfilScreen extends StatefulWidget {
  final MobileUser user; // Recebe o usuário logado
  const PerfilScreen({super.key, required this.user});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen>
    with TickerProviderStateMixin {
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

  void _onTap(BuildContext context, int index, MobileUser user) {
    if (index != 2) {
      Widget screen;
      switch (index) {
        case 0:
          screen = CartaoVirtualScreen(user: user);
          break;
        case 1:
          screen = SolicitarRecargaScreen(user: user);
          break;
        default:
          screen = CartaoVirtualScreen(user: user);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => screen),
      );
    }
  }

  Widget _buildPerfilItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      shadowColor: Colors.pink.shade100,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      color: Colors.white.withOpacity(0.95),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.pink.shade400, size: 28),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 26),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Perfil',
          style: GoogleFonts.poppins(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.pink.shade400,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.pink.shade400),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => CartaoVirtualScreen(user: widget.user)),
            );
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8BBD0), Color(0xFFFFE4EC), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 25, left: 24, right: 24),
          child: ListView(
            children: [
              _buildPerfilItem(
                context: context,
                icon: Icons.settings,
                title: 'Configurações do perfil',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ConfiguracoesPerfilScreen()),
                  );
                },
              ),
              _buildPerfilItem(
  context: context,
  icon: Icons.account_balance_wallet,
  title: 'Minha Carteira',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CarteiraScreen(user: widget.user)),
    );
  },
),
              _buildPerfilItem(
                context: context,
                icon: Icons.description_outlined,
                title: 'Termos de Uso',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TermosUsoScreen()),
                  );
                },
              ),
              _buildPerfilItem(
                context: context,
                icon: Icons.support_agent,
                title: 'Fale Conosco',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FaleConoscoScreen()),
                  );
                },
              ),
              _buildPerfilItem(
                context: context,
                icon: Icons.logout,
                title: 'Fazer Logoff',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const FiebTechApp()),
                  );
                },
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
            currentIndex: 2,
            onTap: (index) => _onTap(context, index, widget.user),
          ),
        ],
      ),
    );
  }
}
