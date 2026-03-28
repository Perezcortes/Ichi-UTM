import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomLoaderScreen extends StatefulWidget {
  final String textoCarga;
  final Widget siguientePantalla; // Recibe la pantalla a la que debe ir

  const CustomLoaderScreen({
    super.key,
    required this.textoCarga,
    required this.siguientePantalla,
  });

  @override
  State<CustomLoaderScreen> createState() => _CustomLoaderScreenState();
}

class _CustomLoaderScreenState extends State<CustomLoaderScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  int _blinkCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _blinkCount++;
        if (_blinkCount < 3) {
          _controller.forward();
        } else {
          Future.delayed(const Duration(milliseconds: 300), () {
            _navigateToNextScreen();
          });
        }
      }
    });

    _controller.forward();
  }

  void _navigateToNextScreen() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        // ¡Usamos la variable dinámica aquí!
        pageBuilder: (context, animation, secondaryAnimation) =>
            widget.siguientePantalla,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cremaUTM,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: guindaUTM.withValues(
                              alpha: _glowAnimation.value * 0.7,
                            ),
                            blurRadius: 50 * _glowAnimation.value,
                            spreadRadius: 25 * _glowAnimation.value,
                          ),
                          BoxShadow(
                            color: doradoUTM.withValues(
                              alpha: _glowAnimation.value,
                            ),
                            blurRadius: 20 * _glowAnimation.value,
                            spreadRadius: 10 * _glowAnimation.value,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Image.asset(
                  'assets/images/loader.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            const SizedBox(height: 50),
            Text(
              // ¡Usamos el texto dinámico aquí!
              widget.textoCarga,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: guindaUTM,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
