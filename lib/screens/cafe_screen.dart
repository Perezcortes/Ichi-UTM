import 'dart:async';
import 'package:flutter/material.dart';
import '../games/juego_cafe/personajeAparece.dart'; // <--- Importamos el widget del cliente

class CafeScreen extends StatefulWidget {
  const CafeScreen({super.key});

  @override
  State<CafeScreen> createState() => _CafeScreenState();
}

class _CafeScreenState extends State<CafeScreen> {
  double posicionX = 0.0;
  String spriteActual = 'assets/personaje/frente.png';
  Timer? temporizadorMovimiento;
  final double velocidad = 0.05;

  void iniciarMovimiento(bool haciaIzquierda) {
    setState(() {
      spriteActual = haciaIzquierda
          ? 'assets/personaje/paso1i.png'
          : 'assets/personaje/paso1d.png';
    });

    temporizadorMovimiento = Timer.periodic(const Duration(milliseconds: 50), (
      timer,
    ) {
      setState(() {
        if (haciaIzquierda) {
          posicionX -= velocidad;
          if (posicionX < -1.0) posicionX = -1.0;
        } else {
          posicionX += velocidad;
          if (posicionX > 1.0) posicionX = 1.0;
        }
      });
    });
  }

  void detenerMovimiento() {
    temporizadorMovimiento?.cancel();
    setState(() {
      spriteActual = 'assets/personaje/frente.png';
    });
  }

  @override
  void dispose() {
    temporizadorMovimiento?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // --- EL MUNDO DEL JUEGO ---
            Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: 800,
                  height: 450,
                  child: Stack(
                    children: [
                      // 1. CAPA DEL FONDO
                      Positioned.fill(
                        child: Image.asset(
                          'assets/fondo/general.jpeg',
                          fit: BoxFit.fill,
                        ),
                      ),
                      // 2. CAPA DEL PERSONAJE
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 50),
                        alignment: Alignment(posicionX, 0.3),
                        child: Image.asset(
                          spriteActual,
                          height: 248,
                          fit: BoxFit.contain,
                        ),
                      ),
                      // 3. CAPA DE LA MESA
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          'assets/fondo/mesa.png',
                          width: 800,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      // 4. CAPA DEL CLIENTE Y EL GLOBO
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 20.0,
                            bottom: 0.0,
                          ),
                          child: PersonajeAparece(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // --- LOS CONTROLES ---
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 20.0,
                  left: 20,
                  right: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTapDown: (_) => iniciarMovimiento(true),
                      onTapUp: (_) => detenerMovimiento(),
                      onTapCancel: () => detenerMovimiento(),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back_ios_new, size: 40),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                      ),
                      onPressed: () {
                        String loQuePidio =
                            llaveCliente.currentState!.nombreDelPedido;
                        llaveCliente.currentState!.entregarPlatillo(loQuePidio);
                      },
                      child: const Text("¡Entregar Pedido! ⭐"),
                    ),
                    GestureDetector(
                      onTapDown: (_) => iniciarMovimiento(false),
                      onTapUp: (_) => detenerMovimiento(),
                      onTapCancel: () => detenerMovimiento(),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_forward_ios, size: 40),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- BOTÓN PARA SALIR DEL JUEGO ---
            Positioned(
              top: 15,
              left: 15,
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop(); // Esto te regresa al mapa
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
