import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'map_screen.dart';
import 'games_screen.dart';
import 'profile_screen.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0; // 0 = Mapa, 1 = Juegos, 2 = Perfil

  // Lista de las pantallas a mostrar
  final List<Widget> _screens = [
    const MapScreen(),
    const GamesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // El cuerpo cambia dependiendo de qué botón tocaste
      body: _screens[_currentIndex],

      // La famosa barra inferior
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Cambia de pantalla al tocar
          });
        },
        backgroundColor: guindaUTM, // Fondo institucional
        selectedItemColor: doradoUTM, // Ícono seleccionado en dorado
        unselectedItemColor: cremaUTM.withValues(
          alpha: 0.6,
        ), // Íconos no seleccionados
        showSelectedLabels: false, // Oculta los textos como pediste
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_esports_outlined),
            activeIcon: Icon(Icons.sports_esports),
            label: 'Juegos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
