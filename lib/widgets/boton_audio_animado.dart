// Archivo: lib/widgets/boton_audio_animado.dart
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

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: doradoUTM.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: doradoUTM, width: 1.5),
            ),
            child: Image.asset('assets/images/ave.png', width: 45, height: 45),
          ),
          const SizedBox(height: 6),
          FadeTransition(
            opacity: _animController,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: guindaUTM,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: guindaUTM.withValues(alpha: 0.4),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Text(
                '👆 Toca para oír',
                style: TextStyle(
                  color: cremaUTM,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
