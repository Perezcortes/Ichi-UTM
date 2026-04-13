// Archivo: lib/games/trivia_jose/preguntas_trivia.dart

class Pregunta {
  final String texto;
  final List<String> opciones;
  final int respuestaCorrecta;
  final String explicacion;

  Pregunta({
    required this.texto,
    required this.opciones,
    required this.respuestaCorrecta,
    required this.explicacion,
  });
}

final Map<String, List<Pregunta>> bancoDePreguntas = {
  'historia': [
    Pregunta(
      texto: '¿Quién es considerado el "Padre de la Computación"?',
      opciones: [
        'John von Neumann',
        'Alan Turing',
        'Charles Babbage',
        'Ada Lovelace',
      ],
      respuestaCorrecta: 1,
      explicacion:
          'Alan Turing formalizó los conceptos de algoritmo y computación con su máquina de Turing.',
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
          'Ada Lovelace concibió el primer algoritmo destinado a ser procesado por la Máquina Analítica en 1843.',
    ),
    Pregunta(
      texto:
          '¿Qué arquitectura define el diseño de la mayoría de las computadoras modernas?',
      opciones: [
        'Arquitectura Harvard',
        'Arquitectura de Turing',
        'Arquitectura ARM',
        'Arquitectura de Von Neumann',
      ],
      respuestaCorrecta: 3,
      explicacion:
          'Propuesta en 1945, describe una computadora con una memoria que contiene tanto datos como instrucciones.',
    ),
    Pregunta(
      texto: '¿Quién inventó el World Wide Web (WWW)?',
      opciones: [
        'Tim Berners-Lee',
        'Vint Cerf',
        'Bill Gates',
        'Linus Torvalds',
      ],
      respuestaCorrecta: 0,
      explicacion:
          'Tim Berners-Lee inventó la Web en 1989 mientras trabajaba en el CERN.',
    ),
  ],
  'codigo': [
    Pregunta(
      texto: 'En la Programación Orientada a Objetos, ¿qué es el Polimorfismo?',
      opciones: [
        'Ocultar los datos internos de una clase',
        'La capacidad de un objeto de tomar muchas formas',
        'Crear múltiples instancias de una clase',
        'La herencia múltiple entre clases',
      ],
      respuestaCorrecta: 1,
      explicacion:
          'El polimorfismo permite que objetos de diferentes clases respondan a la misma llamada de método de su propia manera.',
    ),
    Pregunta(
      texto: '¿Qué significa la notación Big O (O grande) en algoritmos?',
      opciones: [
        'La cantidad de memoria exacta que usa',
        'El número de líneas de código',
        'La complejidad temporal o espacial en el peor de los casos',
        'El tiempo en milisegundos que tarda en compilar',
      ],
      respuestaCorrecta: 2,
      explicacion:
          'Se utiliza en Ciencias de la Computación para describir el rendimiento o la complejidad de un algoritmo.',
    ),
    Pregunta(
      texto: 'En bases de datos relacionales, ¿qué asegura la propiedad ACID?',
      opciones: [
        'Atomicidad, Consistencia, Aislamiento y Durabilidad',
        'Acceso, Control, Integridad y Datos',
        'Asincronía, Concurrencia, Índices y Duplicación',
        'Agrupación, Caché, Inserción y Dependencia',
      ],
      respuestaCorrecta: 0,
      explicacion:
          'Son las propiedades fundamentales que garantizan que las transacciones de base de datos se procesen de manera confiable.',
    ),
  ],
  'cultura': [
    Pregunta(
      texto:
          '¿En qué año fue fundada la Universidad Tecnológica de la Mixteca (UTM)?',
      opciones: ['1988', '1990', '1995', '2000'],
      respuestaCorrecta: 1,
      explicacion:
          'La UTM fue inaugurada oficialmente en el año 1990, siendo el pilar del Sistema de Universidades Estatales de Oaxaca (SUNEO).',
    ),
    Pregunta(
      texto: '¿Cuáles son los colores institucionales oficiales de la UTM?',
      opciones: [
        'Azul y Oro',
        'Rojo y Blanco',
        'Guinda y Crema (Dorado)',
        'Verde y Blanco',
      ],
      respuestaCorrecta: 2,
      explicacion:
          'Los colores que representan a la institución son el Guinda y el tono Crema/Dorado.',
    ),
  ],
};
