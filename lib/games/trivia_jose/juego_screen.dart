// Archivo: lib/games/trivia_jose/juego_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      _guardarYMostrarResultados();
    }
  }

  Future<void> _guardarYMostrarResultados() async {
    final prefs = await SharedPreferences.getInstance();
    String key = 'record_${widget.categoria}';
    int recordActual = prefs.getInt(key) ?? 0;
    bool nuevoRecord = false;

    if (_puntaje > recordActual) {
      await prefs.setInt(key, _puntaje);
      nuevoRecord = true;
    }

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          '¡Evaluación Concluida!',
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              nuevoRecord ? Icons.emoji_events : Icons.verified,
              size: 60,
              color: nuevoRecord ? doradoUTM : guindaUTM,
            ),
            if (nuevoRecord)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  '¡NUEVO RÉCORD!',
                  style: TextStyle(
                    color: doradoUTM,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Text(
              'Aciertos: $_puntaje / ${_preguntas.length}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cierra el diálogo
              Navigator.pop(
                context,
                true,
              ); // Devuelve 'true' al menú para que sepa que terminó
            },
            child: const Text(
              'VOLVER AL MENÚ',
              style: TextStyle(color: guindaUTM, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_preguntas.isEmpty)
      return const Scaffold(
        body: Center(child: Text('No hay preguntas disponibles.')),
      );

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
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),

            // Texto de la pregunta
            Text(
              pregunta.texto,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: guindaUTM,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Lista de opciones
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: pregunta.opciones.length,
                itemBuilder: (context, index) {
                  Color colorBoton = Colors.white;
                  Color colorTexto = Colors.black87;

                  if (_respondido) {
                    if (index == pregunta.respuestaCorrecta) {
                      colorBoton = Colors.green.shade600;
                      colorTexto = Colors.white;
                    } else if (index == _opcionSeleccionada) {
                      colorBoton = Colors.red.shade500;
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
                          color: _respondido
                              ? colorBoton
                              : guindaUTM.withValues(alpha: 0.5),
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

            // Sección inferior: Explicación y botón Siguiente
            if (_respondido) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  pregunta.explicacion,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.blueGrey.shade700,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // --- BOTÓN SEGURO (SAFE AREA) ---
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: ElevatedButton(
                    onPressed: _siguientePregunta,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: guindaUTM,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      _preguntaActualIndex == _preguntas.length - 1
                          ? 'VER RESULTADOS'
                          : 'SIGUIENTE',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
