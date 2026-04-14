import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

class RallyFinalScreen extends StatefulWidget {
  const RallyFinalScreen({super.key});

  @override
  State<RallyFinalScreen> createState() => _RallyFinalScreenState();
}

class _RallyFinalScreenState extends State<RallyFinalScreen> {
  final ScrollController _scrollController = ScrollController();
  
  // --- VARIABLES DE POSICIÓN ---
  double posX = 220;
  double posY = 850; // Inicia desde abajo de la oficina
  
  // --- VARIABLES DE IMAGEN ---
  String imagenActual = 'assets/personaje/quieto.png';

  final double escenarioAncho = 480;
  final double escenarioAlto = 960; 

  bool enZonaDirector = false;
  bool tramiteFirmado = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // --- LÓGICA DE MOVIMIENTO CON JOYSTICK ---
  void _moverJugador(double stickX, double stickY) {
    if (tramiteFirmado) return; // Bloquear movimiento si ya terminó

    setState(() {
      // 1. Actualizar imagen según dirección dominante
      if (stickX.abs() > stickY.abs()) {
        imagenActual = stickX > 0 ? 'assets/personaje/derecha.png' : 'assets/personaje/izquierda.png';
      } else if (stickY.abs() > stickX.abs()) {
        imagenActual = stickY > 0 ? 'assets/personaje/abajo.png' : 'assets/personaje/arriba.png';
      } else if (stickX == 0 && stickY == 0) {
        imagenActual = 'assets/personaje/quieto.png';
      }

      // 2. Mover posición (Velocidad 6)
      posX = (posX + stickX * 6).clamp(0.0, escenarioAncho - 20);
      posY = (posY + stickY * 6).clamp(0.0, escenarioAlto - 20);
      
      _moverCamara();
      _comprobarProximidadDirector();
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

  void _comprobarProximidadDirector() {
    // Zona frente al escritorio del director
    bool cercaDirector = (posX > 180 && posX < 280 && posY > 180 && posY < 280);

    if (cercaDirector && !enZonaDirector && !tramiteFirmado) {
      enZonaDirector = true;
      _mostrarFormularioFinal();
    } else if (!cercaDirector) {
      enZonaDirector = false;
    }
  }

  void _mostrarFormularioFinal() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController careerController = TextEditingController();
    
    const String nombreCorrecto = "Pepito Oropeza";
    const String carreraCorrecta = "Ingenieria en papoi";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("🖋️ Firma del Director", 
          style: TextStyle(color: Color(0xFF800000), fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Confirma tus datos para la firma final:"),
            const SizedBox(height: 15),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nombre", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: careerController,
              decoration: const InputDecoration(labelText: "Carrera", border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().toLowerCase() == nombreCorrecto.toLowerCase() &&
                  careerController.text.trim().toLowerCase() == carreraCorrecta.toLowerCase()) {
                
                Navigator.pop(context); 
                setState(() => tramiteFirmado = true);
                _mostrarFelicidades(nombreCorrecto);
              } else {
                Navigator.pop(context); 
                _mostrarErrorYRegresar(); 
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF800000)),
            child: const Text("SOLICITAR FIRMA", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _mostrarErrorYRegresar() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("❌ Datos Incorrectos", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: const Text("Has sido expulsado por proporcionar información falsa."),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); 
              Navigator.pop(context); 
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("SALIR", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _mostrarFelicidades(String nombreAlumno) {
    final navigator = Navigator.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (modalContext) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.workspace_premium, color: Colors.amber, size: 80),
            const SizedBox(height: 15),
            const Text("🎉 ¡TRÁMITE CONCLUIDO!", 
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 10),
            Text("Felicidades, $nombreAlumno. Has completado el Rally.", 
              textAlign: TextAlign.center),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(modalContext).pop(); 
              navigator.pop(); 
            },
            child: const Text("VOLVER AL MENÚ"),
          ),
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
                    Positioned.fill(
                      child: Image.asset('assets/images/escenarios/oficina_director.png', fit: BoxFit.cover)
                    ),

                    // JUGADOR (Pequeño y dinámico)
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
                    
                    if (!tramiteFirmado)
                      const Positioned(
                        top: 150,
                        left: 215,
                        child: Icon(Icons.arrow_downward, color: Colors.yellowAccent, size: 40),
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
        ],
      ),
    );
  }
}