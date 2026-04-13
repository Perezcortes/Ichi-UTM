import 'dart:async';
import 'package:flutter/material.dart';

// ¡OJO AQUÍ PLUPLU! 👀
// Ajusta estas rutas dependiendo de dónde estén guardados tus archivos en la app general
import '../games/juego_cafe/pedidoAparece.dart';
import '../games/juego_cafe/personajeAparece.dart';

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
  String pedidoActualEscena = '';

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

  int obtenerZonaChef() {
    // Estas zonas las puedes ajustar probando en tu emulador
    // para que coincidan con los contenedores dibujados en tu fondo.
    if (posicionX < -0.6) return 0; // Contenedor 1 (Más a la izquierda)
    if (posicionX < -0.2) return 1; // Contenedor 2
    if (posicionX < 0.2) return 2; // Contenedor 3
    if (posicionX < 0.6) return 3; // Contenedor 4
    return 4; // Zona de Platos (Más a la derecha)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fondo negro para las franjas cuando el celular esté en vertical
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // --- EL MUNDO DEL JUEGO ---
            Center(
              child: FittedBox(
                fit: BoxFit
                    .contain, // Esto hace que TODO se escale junto sin deformarse
                child: SizedBox(
                  // Tamaño VIRTUAL de tu juego
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
                      IgnorePointer(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 50),
                          alignment: Alignment(posicionX, 0.3),
                          child: Image.asset(
                            spriteActual,
                            height: 248,
                            fit: BoxFit.contain,
                          ),
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
                      // 4. CAPA DEL CLIENTE Y EL GLOBO
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 20.0,
                            bottom: 0.0,
                          ),
                          child: PersonajeAparece(
                            onNuevoPedido: (nuevoPedido) {
                              // ¡EL ESCUDO DEL FUTURO! ⏳✨
                              // Future.delayed empuja esta acción completamente
                              // fuera de la construcción de la pantalla.
                              Future.delayed(Duration.zero, () {
                                if (mounted) {
                                  setState(() {
                                    pedidoActualEscena = nuevoPedido;
                                  });
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      // 5. CAPA DE LOS PEDIDOS Y COMIDA
                      Positioned.fill(
                        child: PedidoAparece(
                          nombrePedido: pedidoActualEscena,
                          posicionActualChef: obtenerZonaChef(),
                          onEntregarPedido: () {
                            if (llaveCliente.currentState != null) {
                              llaveCliente.currentState!.entregarPlatillo(
                                pedidoActualEscena,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // --- LOS CONTROLES (Afuera del juego para que siempre estén a la mano) ---
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
                    // BOTÓN IZQUIERDO
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

                    // BOTÓN PARA SALIR DEL JUEGO 🚪🏃‍♂️
                    GestureDetector(
                      onTap: () {
                        // Te regresa al mapa o pantalla anterior
                        Navigator.of(context).pop();
                      },
                      child: Image.asset(
                        'assets/fondo/salir.png',
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                      ),
                    ),

                    // BOTÓN DERECHO
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
          ],
        ),
      ),
    );
  }
}
