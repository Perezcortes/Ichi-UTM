import 'package:flutter/material.dart';

class RallyState extends ChangeNotifier {
  bool tieneContrasena = false;
  int sellosObtenidos = 0;
  bool _disposed = false;

  void recogerContrasena() {
    tieneContrasena = true;
    notifyListeners();
  }

  void resetear() {
    tieneContrasena = false;
    sellosObtenidos = 0;
    notifyListeners();
  }

  // Método simplificado para actualizar el progreso de sellos
  void anadirSello() {
    sellosObtenidos++;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}