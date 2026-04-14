import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_joystick/flutter_joystick.dart'; // Importar el joystick
import 'Contra_game_screen_level2.dart'; 

class RallyGameScreen extends StatefulWidget {
  const RallyGameScreen({super.key});

  @override
  State<RallyGameScreen> createState() => _RallyGameScreenState();
}

class _RallyGameScreenState extends State<RallyGameScreen> {
  // --- VARIABLES DE POSICIÓN ---
  double posX = 220;
  double posY = 220;
  
  // --- VARIABLES DE IMAGEN ---
  // Guardamos la ruta de la imagen actual (por defecto quieto)
  String imagenActual = 'assets/personaje/quieto.png';
  
  final double escenarioAncho = 480;
  final double escenarioAlto = 320;

  // --- VARIABLES DE LÓGICA ---
  bool tieneContrasena = false; 
  bool enZonaRecepcion = false;
  bool enZonaPuerta = false;
  double arrowOffset = 0;
  Timer? timerFlecha;

  @override
  void initState() {
    super.initState();
    _iniciarAnimacionFlecha();
    WidgetsBinding.instance.addPostFrameCallback((_) => _mostrarBienvenida());
  }

  @override
  void dispose() {
    timerFlecha?.cancel();
    super.dispose();
  }

  void _iniciarAnimacionFlecha() {
    timerFlecha = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (mounted) {
        setState(() => arrowOffset = (DateTime.now().millisecondsSinceEpoch % 1000 < 500) ? 0 : 8);
      }
    });
  }

  // --- LÓGICA DE ACTUALIZACIÓN DE IMAGEN Y POSICIÓN ---
  void _moverJugador(double stickX, double stickY) {
    setState(() {
      // 1. Actualizar la imagen según la dirección del Joystick
      if (stickX.abs() > stickY.abs()) {
        imagenActual = stickX > 0 ? 'assets/personaje/derecha.png' : 'assets/personaje/izquierda.png';
      } else if (stickY.abs() > stickX.abs()) {
        imagenActual = stickY > 0 ? 'assets/personaje/abajo.png' : 'assets/personaje/arriba.png';
      } else if (stickX == 0 && stickY == 0) {
        imagenActual = 'assets/personaje/quieto.png';
      }

      // 2. Mover la posición (Multiplicamos por 5 para la velocidad)
      posX = (posX + stickX * 5).clamp(0.0, escenarioAncho - 20);
      posY = (posY + stickY * 5).clamp(0.0, escenarioAlto - 20);
      
      _comprobarProximidad();
    });
  }

  // --- MODALES DE FLUJO (Sin cambios significativos) ---

  void _mostrarBienvenida() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("🎓 Rally: Nivel 1", style: TextStyle(color: Color(0xFF800000), fontWeight: FontWeight.bold)),
        content: const Text("Bienvenido a Servicios Escolares. \n\nUsa el Joystick para acercarte a la recepción."),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF800000)),
            child: const Text("¡EMPEZAR!", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  void _mostrarModalInfo() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("📋 Datos del Alumno"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Alumno: Pepito Oropeza", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Carrera: Ingeniería en Papoi"),
            Text("Matrícula: 2341589"),
            Divider(),
            Text("Pista: Suma los dígitos de tu matrícula para obtener el código de la puerta."),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CERRAR")),
        ],
      ),
    );
  }

  void _mostrarModalPuerta() {
    final TextEditingController codeController = TextEditingController();
    const int sumaCorrecta = 32;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("🚪 Panel de Acceso"),
        content: TextField(
          controller: codeController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Código de acceso"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCELAR")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (codeController.text == sumaCorrecta.toString()) {
                _mostrarResultado(true);
              } else {
                _mostrarResultado(false);
              }
            },
            child: const Text("COMPROBAR"),
          ),
        ],
      ),
    );
  }

  void _mostrarResultado(bool esCorrecto) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (modalContext) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(esCorrecto ? Icons.check_circle : Icons.error, color: esCorrecto ? Colors.green : Colors.red, size: 80),
            const SizedBox(height: 15),
            Text(esCorrecto ? "¡CORRECTO!" : "¡INCORRECTO!", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(esCorrecto ? "Puedes avanzar al siguiente edificio." : "Vuelve a revisar tus datos."),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(modalContext);
              if (esCorrecto) {
                setState(() => tieneContrasena = true);
                _irASiguienteNivel();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: esCorrecto ? Colors.green : Colors.grey),
            child: Text(esCorrecto ? "SIGUIENTE NIVEL" : "REINTENTAR"),
          ),
        ],
      ),
    );
  }

  void _irASiguienteNivel() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RallyLevel2Screen()));
      }
    });
  }

  void _comprobarProximidad() {
    bool cercaRecepcion = (posX > 160 && posX < 260 && posY > 40 && posY < 110);
    bool cercaPuerta = (posX > 10 && posX < 90 && posY > 40 && posY < 110);

    if (cercaRecepcion && !enZonaRecepcion) {
      enZonaRecepcion = true;
      _mostrarModalInfo();
    } else if (!cercaRecepcion) {
      enZonaRecepcion = false;
    }

    if (cercaPuerta && !enZonaPuerta) {
      enZonaPuerta = true;
      _mostrarModalPuerta();
    } else if (!cercaPuerta) {
      enZonaPuerta = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double targetX = tieneContrasena ? 40 : 210;
    double targetY = tieneContrasena ? 30 : 25;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ESCENARIO Y JUEGO
          Center(
            child: Container(
              width: escenarioAncho,
              height: escenarioAlto,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(border: Border.all(color: Colors.brown, width: 4)),
              child: Stack(
                children: [
                  Positioned.fill(child: Image.asset('assets/images/escenarios/recepcion_servicios.png', fit: BoxFit.cover)),
                  
                  // FLECHA INDICADORA
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 400),
                    left: targetX,
                    top: targetY + arrowOffset,
                    child: const Icon(Icons.arrow_downward_rounded, color: Colors.yellowAccent, size: 35),
                  ),

                  // JUGADOR (Cambiado a imagen simple y pequeña)
                  Positioned(
                    left: posX,
                    top: posY,
                    child: Transform.scale(
                      scale: 2, // <--- Cambia este número para ajustar el tamaño (2.0 es el doble, 3.0 el triple)
                      child: Image.asset(
                        imagenActual,
                        width: 25, // Aumentamos un poco el contenedor base
                        height: 25,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // JOYSTICK (Fuera del contenedor del escenario para que sea cómodo tocarlo)
          Positioned(
            bottom: 30,
            left: 30,
            child: Joystick(
              mode: JoystickMode.all,
              listener: (details) => _moverJugador(details.x, details.y),
            ),
          ),
        ],
      ),
    );
  }
}