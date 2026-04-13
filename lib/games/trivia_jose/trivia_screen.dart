import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/constants.dart';
import 'juego_screen.dart';
import 'preguntas_trivia.dart';

class TriviaScreen extends StatefulWidget {
  const TriviaScreen({super.key});

  @override
  State<TriviaScreen> createState() => _TriviaScreenState();
}

class _TriviaScreenState extends State<TriviaScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  // Mapa para guardar los récords visualmente
  Map<String, int> _mejoresPuntajes = {
    'historia': 0,
    'codigo': 0,
    'cultura': 0,
  };

  @override
  void initState() {
    super.initState();
    _cargarPuntajes(); // Carga los puntajes al iniciar

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  // --- FUNCIÓN PARA LEER LA MEMORIA ---
  Future<void> _cargarPuntajes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _mejoresPuntajes['historia'] = prefs.getInt('record_historia') ?? 0;
      _mejoresPuntajes['codigo'] = prefs.getInt('record_codigo') ?? 0;
      _mejoresPuntajes['cultura'] = prefs.getInt('record_cultura') ?? 0;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildCategoriaCard(
    String idCategoria,
    String titulo,
    String subtitulo,
    IconData icono,
  ) {
    int maxPreguntas = bancoDePreguntas[idCategoria]?.length ?? 0;
    int record = _mejoresPuntajes[idCategoria] ?? 0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: cremaUTM,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () async {
          // El await espera a que regreses del juego para recargar los puntajes
          final recargar = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  JuegoScreen(categoria: idCategoria, tituloCategoria: titulo),
            ),
          );
          if (recargar == true) {
            _cargarPuntajes();
          }
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: doradoUTM.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icono, size: 32, color: guindaUTM),
              ),
              const SizedBox(width: 20),
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
                        fontSize: 13,
                        color: Colors.black.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // --- MUESTRA EL RÉCORD ---
                    Row(
                      children: [
                        const Icon(Icons.star, color: doradoUTM, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Récord: $record / $maxPreguntas',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: guindaUTM,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: doradoUTM),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
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
                  'Evaluación Tech',
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
                iconTheme: const IconThemeData(color: guindaUTM),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: guindaUTM,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: guindaUTM.withValues(alpha: 0.3),
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.school,
                    size: 60,
                    color: cremaUTM,
                  ), // Ícono más académico
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Evaluación de Conocimientos',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: guindaUTM,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Selecciona un módulo para poner a prueba tus habilidades académicas.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildCategoriaCard(
                      'historia',
                      'Fundamentos',
                      'Arquitectura y pioneros de la informática.',
                      Icons.memory,
                    ),
                    _buildCategoriaCard(
                      'codigo',
                      'Ingeniería de Software',
                      'Lógica, paradigmas y algoritmos.',
                      Icons.code,
                    ),
                    _buildCategoriaCard(
                      'cultura',
                      'Identidad UTM',
                      'Conocimiento institucional.',
                      Icons.account_balance,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
