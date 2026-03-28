import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'main_navigator.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _iniciarCarga(); // Arrancamos el temporizador en cuanto se abre la pantalla
  }

  void _iniciarCarga() async {
    // 1. Esperamos 3 segundos exactos
    await Future.delayed(const Duration(seconds: 3));

    // 2. Verificamos que el widget siga en pantalla antes de navegar
    if (!mounted) return;

    // 3. Transición difuminada automática hacia el mapa
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MainNavigator(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/entrada_utm.jpeg', fit: BoxFit.cover),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(color: Colors.black.withValues(alpha: 0.4)),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Image.asset('assets/images/logo_sinfondo.png', height: 200),
                const SizedBox(height: 30),
                const Text(
                  'Bienvenido a',
                  style: TextStyle(
                    color: cremaUTM,
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2.0,
                  ),
                ),
                const Text(
                  'ICHI UTM',
                  style: TextStyle(
                    color: doradoUTM,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4.0,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Tu camino por el campus',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const Spacer(),

                // --- NUEVA SECCIÓN DE CARGA AUTOMÁTICA ---
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 60,
                    vertical: 50,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Cargando el campus...',
                        style: TextStyle(
                          color: cremaUTM,
                          fontSize: 15,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 15),
                      // ClipRRect nos ayuda a que la barra tenga bordes curvos y premium
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          backgroundColor: cremaUTM.withValues(
                            alpha: 0.2,
                          ), // Fondo de la barra
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            doradoUTM,
                          ), // Color animado
                          minHeight: 5, // Grosor elegante
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
