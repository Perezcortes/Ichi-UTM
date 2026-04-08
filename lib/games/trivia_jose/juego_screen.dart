import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import 'preguntas_trivia.dart';

class JuegoScreen extends StatefulWidget {
  final String categoria;
  final String tituloCategoria;

  const JuegoScreen({
    super.key,
    required this.categoria,
    required this.tituloCategoria,
  });

  @override
  State<JuegoScreen> createState() => _JuegoScreenState();
}

class _JuegoScreenState extends State<JuegoScreen> {
  int _preguntaActualIndex = 0;
  int _puntaje = 0;
  int? _opcionSeleccionada;
  bool _respondido = false;
  late List<Pregunta> _preguntas;

  @override
  void initState() {
    super.initState();
    // Cargamos las preguntas de la categoría elegida
    _preguntas = bancoDePreguntas[widget.categoria] ?? [];
  }

  void _verificarRespuesta(int index) {
    if (_respondido) return;

    setState(() {
      _opcionSeleccionada = index;
      _respondido = true;
      if (index == _preguntas[_preguntaActualIndex].respuestaCorrecta) {
        _puntaje++;
      }
    });
  }

  void _siguientePregunta() {
    if (_preguntaActualIndex < _preguntas.length - 1) {
      setState(() {
        _preguntaActualIndex++;
        _opcionSeleccionada = null;
        _respondido = false;
      });
    } else {
      _mostrarResultadoFinal();
    }
  }

  void _mostrarResultadoFinal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('¡Trivia Terminada!', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, size: 60, color: doradoUTM),
            const SizedBox(height: 20),
            Text(
              'Tu puntaje: $_puntaje / ${_preguntas.length}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cierra el diálogo
              Navigator.pop(context); // Regresa al menú de trivia
            },
            child: const Text(
              'VOLVER AL MENÚ',
              style: TextStyle(color: guindaUTM),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_preguntas.isEmpty) {
      return Scaffold(
        body: Center(child: Text('No hay preguntas disponibles.')),
      );
    }

    final pregunta = _preguntas[_preguntaActualIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.tituloCategoria),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Indicador de progreso
            LinearProgressIndicator(
              value: (_preguntaActualIndex + 1) / _preguntas.length,
              backgroundColor: Colors.grey.shade200,
              color: doradoUTM,
            ),
            const SizedBox(height: 10),
            Text(
              'Pregunta ${_preguntaActualIndex + 1} de ${_preguntas.length}',
            ),
            const SizedBox(height: 40),

            // Pregunta
            Text(
              pregunta.texto,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: guindaUTM,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Opciones
            Expanded(
              child: ListView.builder(
                itemCount: pregunta.opciones.length,
                itemBuilder: (context, index) {
                  Color colorBoton = Colors.white;
                  Color colorTexto = Colors.black87;

                  if (_respondido) {
                    if (index == pregunta.respuestaCorrecta) {
                      colorBoton = Colors.green.shade400;
                      colorTexto = Colors.white;
                    } else if (index == _opcionSeleccionada) {
                      colorBoton = Colors.red.shade400;
                      colorTexto = Colors.white;
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: OutlinedButton(
                      onPressed: () => _verificarRespuesta(index),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: colorBoton,
                        side: BorderSide(
                          color: _respondido ? colorBoton : guindaUTM,
                        ),
                        padding: const EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        pregunta.opciones[index],
                        style: TextStyle(color: colorTexto, fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Botón Siguiente / Explicación
            if (_respondido) ...[
              Text(
                pregunta.explicacion,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _siguientePregunta,
                style: ElevatedButton.styleFrom(
                  backgroundColor: guindaUTM,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  _preguntaActualIndex == _preguntas.length - 1
                      ? 'VER RESULTADOS'
                      : 'SIGUIENTE',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
