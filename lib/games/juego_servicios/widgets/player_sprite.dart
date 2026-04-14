import 'package:flutter/material.dart';

class PlayerSprite extends StatelessWidget {
  final double size;
  final Offset direction; // Recibe la dirección del joystick

  const PlayerSprite({super.key, required this.size, required this.direction});

  @override
  Widget build(BuildContext context) {
    String imagePath = 'assets/personaje/quieto.png'; // Imagen por defecto

    // Lógica para cambiar la imagen según el vector del Joystick
    if (direction.dx > 0.5) {
      imagePath = 'assets/personaje/derecha.png';
    } else if (direction.dx < -0.5) {
      imagePath = 'assets/personaje/izquierda.png';
    } else if (direction.dy > 0.5) {
      imagePath = 'assets/personaje/abajo.png';
    } else if (direction.dy < -0.5) {
      imagePath = 'assets/personaje/arriba.png';
    }

    return Image.asset(
      imagePath,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}