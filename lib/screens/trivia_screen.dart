import 'package:flutter/material.dart';
import '../utils/constants.dart';

class TriviaScreen extends StatelessWidget {
  const TriviaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cremaUTM,
      appBar: AppBar(
        title: const Text(
          'Trivia Tech UTM',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: guindaUTM,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // Flecha de regreso blanca
      ),
      body: const Center(
        child: Text(
          '¡El juego de Trivia comenzará aquí!',
          style: TextStyle(
            fontSize: 20,
            color: guindaUTM,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
