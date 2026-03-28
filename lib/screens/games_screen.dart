import 'package:flutter/material.dart';
import '../utils/constants.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Juegos', style: TextStyle(color: Colors.white)),
        backgroundColor: guindaUTM,
        centerTitle: true,
      ),
      body: const Center(child: Text('Aquí van los minijuegos')),
    );
  }
}
