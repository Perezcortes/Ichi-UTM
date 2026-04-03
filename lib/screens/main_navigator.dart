import 'dart:ui';
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
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const MapScreen(),
    const GamesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // El mapa sigue escurriéndose por debajo
      body: _screens[_currentIndex],

      // LA BARRA COMPACTA ANCLADA AL PISO
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          // Redondeamos solo las esquinas superiores para que se pegue al fondo
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              color: guindaUTM.withValues(
                alpha: 0.85,
              ), // Cristal entintado guinda
              // SafeArea protege los íconos de la barra de navegación del celular
              child: SafeArea(
                top: false,
                child: SizedBox(
                  height: 65, // ¡Mantiene el tamaño súper compacto!
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildIconoNavegacion(Icons.map_outlined, Icons.map, 0),
                      _buildIconoNavegacion(
                        Icons.sports_esports_outlined,
                        Icons.sports_esports,
                        1,
                      ),
                      _buildIconoNavegacion(
                        Icons.person_outline,
                        Icons.person,
                        2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Nuestro botón de navegación personalizado y animado
  Widget _buildIconoNavegacion(
    IconData iconoNormal,
    IconData iconoActivo,
    int indice,
  ) {
    bool seleccionado = _currentIndex == indice;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = indice;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 65,
        width: 80, // Área de toque un poco más ancha para evitar errores
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, anim) =>
              ScaleTransition(scale: anim, child: child),
          child: Icon(
            seleccionado ? iconoActivo : iconoNormal,
            key: ValueKey<bool>(seleccionado),
            color: seleccionado ? doradoUTM : cremaUTM.withValues(alpha: 0.6),
            size: seleccionado ? 30 : 26,
          ),
        ),
      ),
    );
  }
}
