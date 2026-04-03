import 'dart:ui';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
// Asumiendo que crearás este archivo después para la pantalla de juego real
// import 'juego_screen.dart';

class TriviaScreen extends StatefulWidget {
  const TriviaScreen({super.key});

  @override
  State<TriviaScreen> createState() => _TriviaScreenState();
}

class _TriviaScreenState extends State<TriviaScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Animación de "latido" para el ícono principal
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Widget personalizado para las tarjetas de categoría
  Widget _buildCategoriaCard(
    String titulo,
    String subtitulo,
    IconData icono,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: cremaUTM,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: doradoUTM.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icono, size: 32, color: guindaUTM),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: guindaUTM,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitulo,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: doradoUTM),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo limpio
      // 1. EL TRUCO: Permitir que el body suba
      extendBodyBehindAppBar: true,

      // 2. EL APPBAR ESMERILADO (Glassmorphism)
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AppBar(
                title: const Text(
                  'Trivia Tech UTM',
                  style: TextStyle(
                    color: guindaUTM, // <-- ACENTO GUINDA
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    letterSpacing: -0.5,
                  ),
                ),
                backgroundColor: Colors.white.withValues(
                  alpha: 0.7,
                ), // Translúcido
                elevation: 0,
                centerTitle: true,
                // Botón de regresar en guinda
                iconTheme: const IconThemeData(color: guindaUTM),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // --- CABECERA ANIMADA ---
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: guindaUTM,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: guindaUTM.withValues(alpha: 0.3),
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.lightbulb_outline,
                    size: 60,
                    color: cremaUTM,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                '¡Demuestra lo que sabes!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: guindaUTM,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Selecciona una categoría para empezar el desafío en el Instituto de Computación.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // --- LISTA DE CATEGORÍAS ---
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildCategoriaCard(
                      'Historia Tech',
                      'Pioneros y evolución del software.',
                      Icons.history_edu,
                      () {
                        // Navegar al juego (Implementaremos esto después)
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const JuegoScreen(categoria: 'historia')));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('¡Cargando preguntas de Historia!'),
                          ),
                        );
                      },
                    ),
                    _buildCategoriaCard(
                      'Código Puro',
                      'Lógica, lenguajes y algoritmos.',
                      Icons.code,
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('¡Cargando preguntas de Código!'),
                          ),
                        );
                      },
                    ),
                    _buildCategoriaCard(
                      'Cultura UTM',
                      '¿Qué tanto conoces tu universidad?',
                      Icons.school,
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('¡Cargando preguntas de la UTM!'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
