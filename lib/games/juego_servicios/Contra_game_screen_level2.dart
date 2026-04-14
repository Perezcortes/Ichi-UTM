import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart'; // Importar el joystick
import 'dart:async';
import 'Contra_game_screen_final.dart'; 

class RallyLevel2Screen extends StatefulWidget {
  const RallyLevel2Screen({super.key});

  @override
  State<RallyLevel2Screen> createState() => _RallyLevel2ScreenState();
}

class _RallyLevel2ScreenState extends State<RallyLevel2Screen> {
  final ScrollController _scrollController = ScrollController();
  
  // --- VARIABLES DE POSICIÓN ---
  double posX = 220;
  double posY = 50;
  
  // --- VARIABLES DE IMAGEN ---
  String imagenActual = 'assets/personaje/quieto.png';

  final double escenarioAncho = 480;
  final double escenarioAlto = 960; 

  // --- LÓGICA DE SELLOS ---
  final List<String> ordenCorrecto = ["Verde", "Azul", "Amarillo", "Rojo"];
  List<String> sellosObtenidos = [];
  String? zonaActual;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // --- LÓGICA DE MOVIMIENTO CON JOYSTICK ---
  void _moverJugador(double stickX, double stickY) {
    setState(() {
      // 1. Actualizar imagen según dirección dominante
      if (stickX.abs() > stickY.abs()) {
        imagenActual = stickX > 0 ? 'assets/personaje/derecha.png' : 'assets/personaje/izquierda.png';
      } else if (stickY.abs() > stickX.abs()) {
        imagenActual = stickY > 0 ? 'assets/personaje/abajo.png' : 'assets/personaje/arriba.png';
      } else if (stickX == 0 && stickY == 0) {
        imagenActual = 'assets/personaje/quieto.png';
      }

      // 2. Mover posición (Velocidad ajustada a 6 para un mapa más grande)
      posX = (posX + stickX * 6).clamp(0.0, escenarioAncho - 20);
      posY = (posY + stickY * 6).clamp(0.0, escenarioAlto - 20);
      
      _moverCamara();
      _comprobarCubiculos();
    });
  }

  void _moverCamara() {
    if (!_scrollController.hasClients) return;
    double screenHeight = MediaQuery.of(context).size.height;
    double targetScroll = posY - (screenHeight / 2);

    if (targetScroll < 0) targetScroll = 0;
    if (targetScroll > _scrollController.position.maxScrollExtent) {
      targetScroll = _scrollController.position.maxScrollExtent;
    }
    _scrollController.jumpTo(targetScroll);
  }

  void _comprobarCubiculos() {
    if (posX > 280 && posY > 220 && posY < 360) {
      _intentarRecogerSello("Azul");
    } else if (posX < 180 && posY > 400 && posY < 580) {
      _intentarRecogerSello("Rojo");
    } else if (posY > 750 && posX < 200) {
      _intentarRecogerSello("Verde");
    } else if (posY > 750 && posX > 250) {
      _intentarRecogerSello("Amarillo");
    } else {
      zonaActual = null;
    }
  }

  void _intentarRecogerSello(String colorSello) {
    if (zonaActual == colorSello) return;
    zonaActual = colorSello;
    if (sellosObtenidos.contains(colorSello)) return;

    String colorEsperado = ordenCorrecto[sellosObtenidos.length];

    if (colorSello == colorEsperado) {
      setState(() => sellosObtenidos.add(colorSello));
      _notificar("✅ Sello $colorSello obtenido", Colors.green);
      if (sellosObtenidos.length == 4) _finalizarNivel();
    } else {
      _notificar("❌ Aquí no es. Busca el sello $colorEsperado", Colors.red);
    }
  }

  void _notificar(String msg, Color color) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg, textAlign: TextAlign.center), backgroundColor: color, duration: const Duration(milliseconds: 1000)),
    );
  }

  void _finalizarNivel() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("🎯 ¡Nivel 2 Superado!"),
        content: const Text("Has recolectado todos los sellos. Ahora corre a la Dirección para la firma final."),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); 
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const RallyFinalScreen()),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text("IR A LA DIRECCIÓN", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ESCENARIO CON SCROLL
          SingleChildScrollView(
            controller: _scrollController,
            physics: const NeverScrollableScrollPhysics(),
            child: Center(
              child: SizedBox(
                width: escenarioAncho,
                height: escenarioAlto,
                child: Stack(
                  children: [
                    Positioned.fill(child: Image.asset('assets/images/escenarios/dptos_academicos.png', fit: BoxFit.cover)),
                    _buildGenericMarker(320, 250), 
                    _buildGenericMarker(100, 450), 
                    _buildGenericMarker(100, 800), 
                    _buildGenericMarker(320, 800), 

                    // JUGADOR (Pequeño y con imagen dinámica)
                    Positioned(
                      left: posX,
                      top: posY,
                      child: Transform.scale(
                        scale: 2.5, // <--- Cambia este número para ajustar el tamaño (2.0 es el doble, 3.0 el triple)
                        child: Image.asset(
                          imagenActual,
                          width: 30, // Aumentamos un poco el contenedor base
                          height: 30,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // JOYSTICK
          Positioned(
            bottom: 30,
            left: 30,
            child: Joystick(
              mode: JoystickMode.all,
              listener: (details) => _moverJugador(details.x, details.y),
            ),
          ),

          // PANEL DE PROGRESO
          Positioned(
            top: 40,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.yellowAccent),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text("ORDEN REQUERIDO:", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  const Text("Verde ➔ Azul ➔ Amarillo ➔ Rojo", style: TextStyle(color: Colors.yellowAccent, fontSize: 11)),
                  Text("Progreso: ${sellosObtenidos.length}/4", style: const TextStyle(color: Colors.white, fontSize: 11)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenericMarker(double x, double y) {
    return Positioned(
      left: x,
      top: y,
      child: const Icon(Icons.help_outline, color: Colors.white54, size: 30),
    );
  }
}