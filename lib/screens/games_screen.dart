import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/custom_loader_screen.dart';
import '../games/trivia_jose/trivia_screen.dart'; // Asegúrate de que esta ruta sea correcta

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cremaUTM, // Fondo limpio
      extendBodyBehindAppBar:
          true, // Para que el contenido suba debajo del cristal
      // --- EL APPBAR ESMERILADO (Glassmorphism) ---
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AppBar(
                title: const Text(
                  'Minijuegos UTM',
                  style: TextStyle(
                    color: guindaUTM,
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    letterSpacing: -0.5,
                  ),
                ),
                backgroundColor: Colors.white.withValues(alpha: 0.7),
                elevation: 0,
                centerTitle: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

      // --- EL CATÁLOGO DE JUEGOS ---
      body: ListView(
        // Le damos padding arriba para que no se esconda tras el AppBar
        // y abajo para que no lo tape nuestra barra de navegación anclada
        padding: const EdgeInsets.only(
          top: 100,
          left: 24,
          right: 24,
          bottom: 120,
        ),
        children: [
          const Text(
            'Actividades Disponibles',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: guindaUTM,
            ),
          ),
          const SizedBox(height: 20),

          // 🎮 TARJETA DE TU JUEGO: TRIVIA TECH UTM
          _buildGameCard(
            context: context,
            titulo: 'Trivia Tech UTM',
            subtitulo:
                'Demuestra tus conocimientos en el Inst. de Computación.',
            icono: Icons.videogame_asset,
            pantallaDestino: const TriviaScreen(),
            textoCarga: 'Cargando Trivia...',
          ),

          const SizedBox(height: 15),

          // 🔒 TARJETA DE PRÓXIMO JUEGO (Para rellenar y que se vea profesional)
          _buildGameCardLocked(
            titulo: 'Rally Universitario',
            subtitulo:
                'Próximamente: Encuentra los códigos QR por todo el campus.',
            icono: Icons.qr_code_scanner,
          ),
        ],
      ),
    );
  }

  // --- WIDGET REUTILIZABLE PARA JUEGOS ACTIVOS ---
  Widget _buildGameCard({
    required BuildContext context,
    required String titulo,
    required String subtitulo,
    required IconData icono,
    required Widget pantallaDestino,
    required String textoCarga,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // ¡MAGIA! Llamamos a tu loader screen antes de abrir el juego
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CustomLoaderScreen(
                  textoCarga: textoCarga,
                  siguientePantalla: pantallaDestino,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Ícono del juego
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: doradoUTM.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icono, size: 32, color: guindaUTM),
                ),
                const SizedBox(width: 20),
                // Textos
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: guindaUTM,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitulo,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                // Flecha indicadora
                const Icon(Icons.arrow_forward_ios, color: doradoUTM),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET REUTILIZABLE PARA JUEGOS BLOQUEADOS ---
  Widget _buildGameCardLocked({
    required String titulo,
    required String subtitulo,
    required IconData icono,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100, // Color apagado
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: Icon(icono, size: 32, color: Colors.grey.shade500),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitulo,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            Icon(Icons.lock_outline, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
