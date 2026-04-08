// Archivo: lib/games/trivia_jose/preguntas_trivia.dart

class Pregunta {
  final String texto;
  final List<String> opciones;
  final int respuestaCorrecta; // Índice de la lista (0 a 3)
  final String explicacion;

  Pregunta({
    required this.texto,
    required this.opciones,
    required this.respuestaCorrecta,
    required this.explicacion,
  });
}

// Mapa que organiza las preguntas por categorías
final Map<String, List<Pregunta>> bancoDePreguntas = {
  'historia': [
    Pregunta(
      texto: '¿Quién es considerado el "Padre de la Computación"?',
      opciones: ['Bill Gates', 'Alan Turing', 'Steve Jobs', 'Ada Lovelace'],
      respuestaCorrecta: 1,
      explicacion:
          'Alan Turing diseñó la máquina de Turing y descifró el código Enigma en la 2da Guerra Mundial.',
    ),
    Pregunta(
      texto: '¿Cuál fue la primera programadora de la historia?',
      opciones: [
        'Grace Hopper',
        'Margaret Hamilton',
        'Ada Lovelace',
        'Joan Clarke',
      ],
      respuestaCorrecta: 2,
      explicacion:
          'Ada Lovelace escribió el primer algoritmo destinado a ser procesado por una máquina en 1843.',
    ),
  ],
  'codigo': [
    Pregunta(
      texto:
          'En Flutter, ¿qué widget se usa para apilar elementos uno sobre otro (eje Z)?',
      opciones: ['Column', 'Row', 'Stack', 'ListView'],
      respuestaCorrecta: 2,
      explicacion:
          'El widget Stack permite colocar widgets encima de otros, como capas.',
    ),
    Pregunta(
      texto: '¿Qué lenguaje de programación es la base de Flutter?',
      opciones: ['Java', 'Swift', 'Python', 'Dart'],
      respuestaCorrecta: 3,
      explicacion:
          'Dart es el lenguaje optimizado para UI creado por Google que utiliza Flutter.',
    ),
  ],
  'cultura': [
    Pregunta(
      texto: '¿Qué significa la sigla UTM?',
      opciones: [
        'Universidad Técnica de México',
        'Universidad Tecnológica de la Mixteca',
        'Unión de Tecnologías Modernas',
        'Universidad de Telecomunicaciones y Matemáticas',
      ],
      respuestaCorrecta: 1,
      explicacion:
          'La UTM es la máxima casa de estudios de la región Mixteca, fundada en 1990.',
    ),
  ],
};
