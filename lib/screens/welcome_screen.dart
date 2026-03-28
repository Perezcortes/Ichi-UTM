import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'main_navigator.dart'; // Importamos el nuevo contenedor

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 40,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 800),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const MainNavigator(), // ¡Cambio aquí!
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: guindaUTM,
                      foregroundColor: cremaUTM,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(color: doradoUTM, width: 2),
                      ),
                      elevation: 8,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'COMENZAR EL RECORRIDO',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
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
