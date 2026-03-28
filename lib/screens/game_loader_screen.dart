import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'trivia_screen.dart';

class GameLoaderScreen extends StatefulWidget {
  const GameLoaderScreen({super.key});

  @override
  State<GameLoaderScreen> createState() => _GameLoaderScreenState();
}

class _GameLoaderScreenState extends State<GameLoaderScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  int _blinkCount = 0; // Contador de parpadeos

  @override
  void initState() {
    super.initState();

    // 1. Configuramos el motor de la animación (duración de medio parpadeo)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ), // Tiempo en "encenderse" o "apagarse"
    );

    // 2. Definimos cómo cambia la intensidad del brillo (0.0 a 1.0)
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // 3. LA LÓGICA DEL CONTADOR DE 3 PARPADEOS
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Se terminó de encender, ahora mandamos a apagar
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        // Se terminó de apagar (un parpadeo completo)
        _blinkCount++;

        if (_blinkCount < 3) {
          // Aún no llegamos a 3, iniciamos el siguiente parpadeo
          _controller.forward();
        } else {
          // ¡Llegamos a 3! Esperamos un momento y navegamos
          Future.delayed(const Duration(milliseconds: 300), () {
            _navigateToGame();
          });
        }
      }
    });

    // Arrancamos el primer parpadeo
    _controller.forward();
  }

  void _navigateToGame() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const TriviaScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Importante limpiar memoria
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cremaUTM,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Stack permite encimar el sombreado animado detrás de la imagen
            Stack(
              alignment: Alignment.center,
              children: [
                // --- 1. EL SOMBREADO/BRILLO
                AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (context, child) {
                    return Container(
                      width:
                          100, // Ligeramente más pequeño que la imagen para que el brillo nazca desde adentro
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          // Capa 1: Resplandor amplio y difuminado (Expansión lejana)
                          BoxShadow(
                            color: guindaUTM.withValues(
                              alpha: _glowAnimation.value * 0.7,
                            ),
                            blurRadius: 50 * _glowAnimation.value,
                            spreadRadius: 25 * _glowAnimation.value,
                          ),
                          // Capa 2: Núcleo del brillo
                          BoxShadow(
                            color: doradoUTM.withValues(
                              alpha: _glowAnimation.value,
                            ),
                            blurRadius: 20 * _glowAnimation.value,
                            spreadRadius: 10 * _glowAnimation.value,
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // --- 2. LA IMAGEN DEL LOADER (FIJA) ---
                Image.asset(
                  'assets/images/loader.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ],
            ),

            const SizedBox(height: 50),

            const Text(
              'Preparando Trivia Tech...',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: guindaUTM,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
