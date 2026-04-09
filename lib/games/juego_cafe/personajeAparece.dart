import 'dart:math';
import 'package:flutter/material.dart';
import '../juego_cafe/pedido.dart'; // <--- Aquí va tu lógica para verificar pedidos

// Necesitamos una llave global para poder enviarle el "platillo" desde el main.dart
GlobalKey<PersonajeApareceState> llaveCliente = GlobalKey();

class PersonajeAparece extends StatefulWidget {
  PersonajeAparece({Key? key}) : super(key: key ?? llaveCliente);

  @override
  State<PersonajeAparece> createState() => PersonajeApareceState();
}

class PersonajeApareceState extends State<PersonajeAparece>
    with SingleTickerProviderStateMixin {
  final Random _random = Random();

  // ⚠️ CAMBIA ESTOS NOMBRES POR LOS QUE TENGAS EN TU CARPETA assets/clientes/
  final List<String> listaClientes = [
    'assets/clientes/chica1.png',
    'assets/clientes/chica2.png',
    'assets/clientes/chico1.png',
    'assets/clientes/chico2.png',
  ];

  // Tus pedidos reales
  final List<String> listaPedidos = [
    'assets/pedidos/cafePan.png',
    'assets/pedidos/desayuno.png',
    'assets/pedidos/dosTaco.png',
    'assets/pedidos/unTaco.png',
  ];

  late String clienteActual;
  late String pedidoActual;
  late String nombreDelPedido; // Aquí guardaremos "cafePan" o "unTaco"

  // Variables para la magia del humo
  late AnimationController _controladorHumo;
  late Animation<double> _escalaHumo;
  bool mostrandoHumo = false;
  bool mostrarCliente = true;

  @override
  void initState() {
    super.initState();
    _generarNuevoCliente();

    // Configuramos la animación del humo para que dure medio segundo
    _controladorHumo = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // El humo empezará chiquito (0.5) y crecerá hasta cubrirlo (3.0)
    _escalaHumo = Tween<double>(
      begin: 0.4,
      end: 3.1,
    ).animate(CurvedAnimation(parent: _controladorHumo, curve: Curves.easeIn));

    // Estar atentos a lo que pasa con la animación
    _controladorHumo.addListener(() {
      // Cuando el humo va por el 60% de su tamaño, ocultamos al cliente
      if (_controladorHumo.value > 0.6 && mostrarCliente) {
        setState(() {
          mostrarCliente = false;
        });
      }
    });

    _controladorHumo.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Cuando termina el humo, reseteamos todo y traemos a otro cliente
        setState(() {
          mostrandoHumo = false;
          mostrarCliente = true;
          _generarNuevoCliente();
        });
        _controladorHumo.reset();
      }
    });
  }

  void _generarNuevoCliente() {
    clienteActual = listaClientes[_random.nextInt(listaClientes.length)];
    pedidoActual = listaPedidos[_random.nextInt(listaPedidos.length)];

    // Extraemos el nombre. Si es 'assets/pedidos/cafePan.png', esto saca 'cafePan'
    nombreDelPedido = pedidoActual.split('/').last.split('.').first;
  }

  // ESTA FUNCIÓN ES LA QUE RECIBE EL PLATILLO TERMINADO
  void entregarPlatillo(String platilloPreparado) {
    if (mostrandoHumo) return; // Si ya se está yendo, ignoramos

    // Vamos a tu archivo pedido.dart a comparar
    bool coinciden = ControlPedido.verificarPedido(
      nombreDelPedido,
      platilloPreparado,
    );

    if (coinciden) {
      // ¡Si coinciden, iniciamos la animación del humo!
      setState(() {
        mostrandoHumo = true;
      });
      _controladorHumo.forward();
    } else {
      print("¡Ups! Pidió $nombreDelPedido y le diste $platilloPreparado");
    }
  }

  @override
  void dispose() {
    _controladorHumo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 570, // Alto suficiente para el globo y el cliente
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // 1. EL CLIENTE Y EL GLOBO
          if (mostrarCliente)
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Globo de pensamiento (Pedido)
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 1, // Lo separamos un poco del cliente
                  ), // ¡Los 10px de distancia que pediste!
                  padding: const EdgeInsets.all(
                    1,
                  ), // Un poco de espacio dentro del globo
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.brown, width: 2),
                  ),
                  child: Image.asset(
                    pedidoActual,
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                ),
                // Imagen del Cliente
                Transform.translate(
                  // Offset(Eje X, Eje Y). El 11 positivo lo empuja hacia ABAJO.
                  offset: const Offset(0, 35),
                  child: Image.asset(
                    clienteActual,
                    height: 350, // Tu altura ideal
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),

          // 2. EL HUMO (Se dibuja encima de todo)
          if (mostrandoHumo)
            Positioned(
              bottom:
                  100, // Lo subimos un poco para que nazca del centro del cliente
              child: AnimatedBuilder(
                animation: _escalaHumo,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _escalaHumo.value,
                    child: Image.asset(
                      'assets/personaje/desaparece/smoke.png',
                      height: 80,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
