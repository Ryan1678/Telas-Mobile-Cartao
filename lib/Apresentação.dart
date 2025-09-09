import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cartao_virtual.dart';
import 'login.dart'; // onde está a MobileUser

class PresentationScreen extends StatelessWidget {
  final MobileUser user; // Recebe o MobileUser

  const PresentationScreen({super.key, required this.user}); // Construtor atualizado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Column(
                        children: [
                          Image.asset('assets/images/logo-fieb.png', height: 60),
                          const SizedBox(height: 16),
                          Image.asset('assets/images/cartao.png', height: 160),
                        ],
                      ),
                      const SizedBox(height: 32),

                      Text(
                        'Tenha mais praticidade!',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink.shade600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        'Seja bem-vindo, ${user.nome}! Desfrute da rapidez para comprar o que quiser na instituição FIEB que você estuda.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),

                      // Exemplo: exibir dados adicionais do cliente se existirem
                      if (user.tipoCliente != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Tipo Cliente: ${user.tipoCliente}',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      const Spacer(),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50.0, vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                           Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CartaoVirtualScreen(user: user)),
        );
                        },
                        child: Text(
                          'Próximo',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
