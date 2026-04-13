import 'package:flutter/material.dart';
import 'dart:math';

class PedidoAparece extends StatefulWidget {
  final int posicionActualChef;
  final VoidCallback onEntregarPedido;
  final String nombrePedido;

  const PedidoAparece({
    super.key,
    required this.posicionActualChef,
    required this.onEntregarPedido,
    required this.nombrePedido,
  });

  @override
  State<PedidoAparece> createState() => _PedidoApareceState();
}

class _PedidoApareceState extends State<PedidoAparece> {
  late Map<int, int> contenedores;
  int pasoActual = 1;

  // Controla qué hay exactamente en el plato verde
  String itemEnPlato = '';
  int estadoCafe = 0;

  @override
  void initState() {
    super.initState();
    _iniciarJuego();
  }

  @override
  void didUpdateWidget(PedidoAparece oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.nombrePedido != oldWidget.nombrePedido) {
      _iniciarJuego();
    }
  }

  void _iniciarJuego() {
    itemEnPlato = '';
    estadoCafe =
        (widget.nombrePedido == 'desayuno' || widget.nombrePedido == 'cafePan')
        ? 1
        : 0;
    _reiniciarCocina();
  }

  void _reiniciarCocina() {
    List<int> ingredientes;

    // Si es cafePan, solo usamos 2 ingredientes (pan1 y pan2), y 2 ollas vacías
    if (widget.nombrePedido == 'cafePan') {
      ingredientes = [1, 2, 0, 0];
    } else {
      // Para tacos y desayuno usamos 4 ingredientes
      ingredientes = [1, 2, 3, 4];
    }

    ingredientes.shuffle(Random());
    contenedores = {
      0: ingredientes[0],
      1: ingredientes[1],
      2: ingredientes[2],
      3: ingredientes[3],
    };
    pasoActual = 1;
  }

  // Helper para saber qué carpeta usar dependiendo del pedido
  String _obtenerRutaIngrediente(int nivel) {
    if (widget.nombrePedido == 'desayuno') {
      return 'assets/Desayuno/desay$nivel.png';
    } else if (widget.nombrePedido == 'cafePan') {
      return 'assets/cafe/pan$nivel.png'; // <--- OJO: Asegúrate que la carpeta se llame "Pan" y no "pan"
    } else {
      return 'assets/taco/taco$nivel.png';
    }
  }

  Widget _buildContenedor(int indexContenedor) {
    int nivelTacoAqui = contenedores[indexContenedor]!;
    String rutaImagen = _obtenerRutaIngrediente(nivelTacoAqui);

    return DragTarget<int>(
      onWillAcceptWithDetails: (details) {
        int indexOrigen = details.data;
        int nivelArrastrado = contenedores[indexOrigen]!;
        return nivelArrastrado == pasoActual && nivelTacoAqui == pasoActual + 1;
      },
      onAcceptWithDetails: (details) {
        int indexOrigen = details.data;
        setState(() {
          contenedores[indexOrigen] = 0;
          pasoActual++;
        });
      },
      builder: (context, candidateData, rejectedData) {
        bool resaltado = candidateData.isNotEmpty;

        return Container(
          width: 90,
          height: 90,
          margin: const EdgeInsets.only(right: 18, left: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: resaltado ? Colors.green : Colors.transparent,
              width: 3.5,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (nivelTacoAqui > 0)
                Draggable<int>(
                  data: indexContenedor,
                  maxSimultaneousDrags:
                      (nivelTacoAqui == pasoActual &&
                          widget.posicionActualChef == indexContenedor)
                      ? 1
                      : 0,
                  feedback: Material(
                    color: Colors.transparent,
                    child: Image.asset(rutaImagen, width: 80, height: 80),
                  ),
                  childWhenDragging: Opacity(
                    opacity: 0.3,
                    child: Image.asset(rutaImagen, width: 80, height: 80),
                  ),
                  child: Image.asset(rutaImagen, width: 80, height: 80),
                ),
              if (widget.posicionActualChef == indexContenedor)
                const Positioned(
                  bottom: -15,
                  child: Text('👨‍🍳', style: TextStyle(fontSize: 20)),
                ),
            ],
          ),
        );
      },
    );
  }

  // Dibuja lo que hay en el plato final
  Widget _dibujarPlatoFinal() {
    String ruta = '';
    if (itemEnPlato == 'taco5') ruta = 'assets/taco/taco5.png';
    if (itemEnPlato == 'dosTaco') ruta = 'assets/taco/dosTaco.png';
    if (itemEnPlato == 'desay4') ruta = 'assets/Desayuno/desay4.png';
    if (itemEnPlato == 'desay5') ruta = 'assets/Desayuno/desay5.png';
    if (itemEnPlato == 'pan2') ruta = 'assets/cafe/pan2.png';
    if (itemEnPlato == 'pan3') ruta = 'assets/cafe/pan3.png';

    if (ruta.isEmpty) return const SizedBox();
    return Image.asset(ruta, width: 80, height: 80);
  }

  // Construye la zona de la cafetera
  Widget _construirCafetera() {
    if (estadoCafe == 0) return const SizedBox();

    return Positioned(
      bottom: 178,
      left: 156,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (estadoCafe == 1) {
            setState(() {
              estadoCafe = 2;
            });
            Future.delayed(const Duration(milliseconds: 1000), () {
              if (mounted) {
                setState(() {
                  estadoCafe = 3;
                });
              }
            });
          }
        },
        child: Container(
          width: 80,
          height: 80,
          color: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (estadoCafe == 1)
                Image.asset('assets/cafe/cafe1.png', width: 70, height: 70),
              if (estadoCafe == 2)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset('assets/cafe/cafe1.png', width: 70, height: 70),
                    Image.asset(
                      'assets/personaje/desaparece/smoke.png',
                      width: 80,
                      height: 80,
                    ),
                  ],
                ),
              if (estadoCafe == 3)
                Draggable<String>(
                  data: 'cafe2',
                  maxSimultaneousDrags: 1,
                  onDragCompleted: () {
                    if (mounted) {
                      setState(() {
                        estadoCafe = 0;
                      });
                    }
                  },
                  feedback: Material(
                    color: Colors.transparent,
                    child: Image.asset(
                      'assets/cafe/cafe2.png',
                      width: 70,
                      height: 70,
                    ),
                  ),
                  childWhenDragging: Opacity(
                    opacity: 0.3,
                    child: Image.asset(
                      'assets/cafe/cafe2.png',
                      width: 70,
                      height: 70,
                    ),
                  ),
                  child: Image.asset(
                    'assets/cafe/cafe2.png',
                    width: 70,
                    height: 70,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.nombrePedido != 'unTaco' &&
        widget.nombrePedido != 'dosTaco' &&
        widget.nombrePedido != 'desayuno' &&
        widget.nombrePedido != 'cafePan') {
      return const SizedBox();
    }

    return Stack(
      children: [
        // 1. LOS CONTENEDORES DE METAL (Abajo)
        Positioned(
          bottom: 140,
          left: 45,
          child: Row(
            children: List.generate(4, (index) => _buildContenedor(index)),
          ),
        ),

        // LA ZONA DE LA CAFETERA ¡SE FUE A SU PROPIO WIDGET AL FINAL DE ESTE ARCHIVO!
        _construirCafetera(),
        // 2. LA ZONA DE PLATOS VERDES
        Positioned(
          bottom: 115,
          right: 180,
          child: DragTarget<Object>(
            onWillAcceptWithDetails: (details) {
              if (details.data is int) {
                int indexOrigen = details.data as int;
                int nivelArrastrado = contenedores[indexOrigen]!;

                // Lógica de Pan (Solo llega al paso 2)
                if (widget.nombrePedido == 'cafePan') {
                  if (nivelArrastrado == 2 &&
                      pasoActual == 2 &&
                      itemEnPlato == '')
                    return true;
                } else {
                  // Lógica de Tacos y Desayuno (Llegan al paso 4)
                  if (nivelArrastrado == 4 && pasoActual == 4) {
                    if (widget.nombrePedido == 'unTaco' && itemEnPlato == '')
                      return true;
                    if (widget.nombrePedido == 'dosTaco' &&
                        (itemEnPlato == '' || itemEnPlato == 'taco5'))
                      return true;
                    if (widget.nombrePedido == 'desayuno' && itemEnPlato == '')
                      return true;
                  }
                }
              } else if (details.data is String) {
                // Viene de la cafetera externa
                if (details.data == 'cafe2' && itemEnPlato == 'desay4')
                  return true;
                if (details.data == 'cafe2' && itemEnPlato == 'pan2')
                  return true;
              }
              return false;
            },
            onAcceptWithDetails: (details) {
              setState(() {
                if (details.data is int) {
                  // Soltaron la comida de las ollas
                  contenedores[details.data as int] = 0;

                  if (widget.nombrePedido == 'unTaco') itemEnPlato = 'taco5';
                  if (widget.nombrePedido == 'dosTaco')
                    itemEnPlato = (itemEnPlato == '') ? 'taco5' : 'dosTaco';
                  if (widget.nombrePedido == 'desayuno') itemEnPlato = 'desay4';
                  if (widget.nombrePedido == 'cafePan') itemEnPlato = 'pan2';

                  _reiniciarCocina();
                } else if (details.data == 'cafe2') {
                  // Soltaron el café
                  if (itemEnPlato == 'desay4') itemEnPlato = 'desay5';
                  if (itemEnPlato == 'pan2') itemEnPlato = 'pan3';
                }
              });
            },
            builder: (context, candidateData, rejectedData) {
              bool listoParaEntregar = false;
              String dataParaEntregar = '';

              if (widget.nombrePedido == 'unTaco' && itemEnPlato == 'taco5') {
                listoParaEntregar = true;
                dataParaEntregar = 'unTaco';
              }
              if (widget.nombrePedido == 'dosTaco' &&
                  itemEnPlato == 'dosTaco') {
                listoParaEntregar = true;
                dataParaEntregar = 'dosTaco';
              }
              if (widget.nombrePedido == 'desayuno' &&
                  itemEnPlato == 'desay5') {
                listoParaEntregar = true;
                dataParaEntregar = 'desayuno';
              }
              if (widget.nombrePedido == 'cafePan' && itemEnPlato == 'pan3') {
                listoParaEntregar = true;
                dataParaEntregar = 'cafePan';
              }

              return Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: candidateData.isNotEmpty
                        ? Colors.greenAccent
                        : Colors.transparent,
                    width: 4,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (itemEnPlato.isNotEmpty)
                      Draggable<String>(
                        data: dataParaEntregar,
                        maxSimultaneousDrags:
                            (widget.posicionActualChef == 4 &&
                                listoParaEntregar)
                            ? 1
                            : 0,
                        feedback: Material(
                          color: Colors.transparent,
                          child: _dibujarPlatoFinal(),
                        ),
                        childWhenDragging: const Opacity(
                          opacity: 0.3,
                          child: Icon(
                            Icons.check_circle,
                            size: 50,
                            color: Colors.green,
                          ),
                        ),
                        child: _dibujarPlatoFinal(),
                      ),
                    if (widget.posicionActualChef == 4)
                      const Positioned(
                        bottom: -15,
                        child: Text('👨‍🍳', style: TextStyle(fontSize: 20)),
                      ),
                  ],
                ),
              );
            },
          ),
        ),

        // 3. LA ZONA DE ENTREGA AL CLIENTE
        Align(
          alignment: Alignment.bottomRight,
          child: DragTarget<String>(
            onWillAcceptWithDetails: (details) =>
                details.data == widget.nombrePedido,
            onAcceptWithDetails: (details) {
              setState(() {
                _iniciarJuego();
              });
              widget.onEntregarPedido();
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                width: 150,
                height: 350,
                margin: const EdgeInsets.only(right: 20),
                color: candidateData.isNotEmpty
                    ? Colors.green.withOpacity(0.3)
                    : Colors.transparent,
              );
            },
          ),
        ),
      ],
    );
  }
}
