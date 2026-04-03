import 'package:flutter/material.dart';
import '../utils/constants.dart';

class BotonAudioAnimado extends StatefulWidget {
  final VoidCallback onTap;

  const BotonAudioAnimado({super.key, required this.onTap});

  @override
  State<BotonAudioAnimado> createState() => _BotonAudioAnimadoState();
}

class _BotonAudioAnimadoState extends State<BotonAudioAnimado>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Inicializamos el controlador de tiempo
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 800,
      ), // Aparece suavemente en casi 1 segundo
    );

    // 2. ¡AQUÍ ESTÁ LA SOLUCIÓN! Le damos su valor a _fadeAnimation antes de usarla
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );

    // 3. Arrancamos la secuencia: Aparecer -> Esperar 3 segs -> Desaparecer
    _iniciarSecuenciaInstruccion();
  }

  void _iniciarSecuenciaInstruccion() async {
    _animController.forward();
    await Future.delayed(const Duration(seconds: 3));
    // Comprobamos si el widget sigue en pantalla antes de animarlo de salida
    if (mounted) {
      _animController.reverse();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // GestureDetector envuelve todo para que tanto el ave como el texto sean "tocables"
    return GestureDetector(
      onTap: widget.onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- LA ETIQUETA ANIMADA PREMIUM ---
          FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: cremaUTM.withValues(alpha: 0.95), // Crema translúcido
                borderRadius: BorderRadius.circular(
                  20,
                ), // Bordes súper redondos
                border: Border.all(
                  color: guindaUTM.withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  // Ícono en lugar del emoji
                  Icon(Icons.volume_up, size: 14, color: guindaUTM),
                  SizedBox(width: 4),
                  Text(
                    'Toca para oír',
                    style: TextStyle(
                      color: guindaUTM,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8), // Separación entre la etiqueta y el ave
          // --- EL AVE (TAPACAMINOS) ---
          Image.asset('assets/images/ave.png', width: 50, height: 50),
        ],
      ),
    );
  }
}
