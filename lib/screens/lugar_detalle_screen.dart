import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../widgets/custom_loader_screen.dart';
import '../widgets/boton_audio_animado.dart';
import '../games/trivia_jose/trivia_screen.dart';
import '../games/juego_servicios/Contra_game_screen.dart';
import '../utils/constants.dart';
import 'cafe_screen.dart'; // <--- EL NUEVO IMPORT

class LugarDetalleScreen extends StatefulWidget {
  final Map<String, dynamic> lugar;

  const LugarDetalleScreen({super.key, required this.lugar});

  @override
  State<LugarDetalleScreen> createState() => _LugarDetalleScreenState();
}

class _LugarDetalleScreenState extends State<LugarDetalleScreen> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _reproducirAudio(String texto, String idioma) async {
    await flutterTts.setLanguage(idioma);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(texto);
  }

  /// --- WIDGET INTELIGENTE ---
  /// Detecta si la ruta es un asset local o una URL de internet
  Widget _buildAdaptiveImage(
    String path, {
    BoxFit fit = BoxFit.cover,
    double? height,
    double? width,
  }) {
    // Si empieza con http, es de internet
    if (path.startsWith('http')) {
      return Image.network(
        path,
        fit: fit,
        height: height,
        width: width ?? double.infinity,
        // Pequeño loader mientras carga la imagen de internet
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.black12,
            height: height,
            child: const Center(
              child: CircularProgressIndicator(color: guindaUTM),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.black26,
          child: const Icon(Icons.broken_image, size: 50),
        ),
      );
    } else {
      // De lo contrario, asumimos que es un Asset local
      return Image.asset(
        path,
        fit: fit,
        height: height,
        width: width ?? double.infinity,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.black26,
          child: const Icon(Icons.broken_image, size: 50),
        ),
      );
    }
  }

  // --- EL DIÁLOGO QUE PREGUNTA EL IDIOMA ---
  void _preguntarIdioma(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: cremaUTM,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Image.asset('assets/images/ave.png', width: 40, height: 40),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  '¿En qué idioma deseas escucharlo?',
                  style: TextStyle(
                    color: guindaUTM,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: const Text(
            'El Tapacaminos leerá la información para ti.',
            style: TextStyle(color: Colors.black87),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            // 1. ESPAÑOL
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _reproducirAudio(widget.lugar['descripcion'], 'es-MX');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: guindaUTM,
                foregroundColor: cremaUTM,
              ),
              child: const Text(
                'Español',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            // 2. INGLÉS
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                String textoEn =
                    widget.lugar['descripcion_en'] ??
                    "English translation coming soon.";
                _reproducirAudio(textoEn, 'en-US');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: doradoUTM,
                foregroundColor: guindaUTM,
              ),
              child: const Text(
                'English',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            // 3. MIXTECO (Botón demostrativo)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      '🦉 ¡Pronto el Tapacaminos hablará en Tu\'un Savi (Mixteco)!',
                    ),
                    backgroundColor: guindaUTM,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: cremaUTM,
              ),
              child: const Text(
                'Mixteco',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  /// --- VISTA PANORÁMICA MEJORADA (UX Fix) ---
  void _abrirVisor360() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Exploración del Lugar'),
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.black,
          // Usamos un solo visor nativo limpio
          body: Container(
            color: Colors.black,
            // Contenedor de pantalla completa
            child: SizedBox.expand(
              child: InteractiveViewer(
                key: const ValueKey('panorama_viewer'),
                panEnabled: true, // ¡Arranque activado!
                scaleEnabled: true, // Zoom activado
                minScale: 1.0, // Empieza full screen
                maxScale: 4.0, // Zoom hasta 4x
                boundaryMargin: const EdgeInsets.all(
                  20,
                ), // Margen para sentir los bordes
                // Center + BoxFit.cover = Experiencia inmersiva que desliza
                child: Center(
                  child: Image.asset(
                    widget.lugar['imagen360'] ??
                        'assets/images/InstComputacion.jpg',
                    // ¡TRUCO DE UX! Cover llena la pantalla y desborda a los lados para arrastrar
                    fit: BoxFit.cover,
                    width: double.infinity,
                    // Dejamos que el InteractiveViewer maneje el alto
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> galeria = widget.lugar['galeria'] ?? [];

    return Scaffold(
      backgroundColor: cremaUTM,
      body: CustomScrollView(
        slivers: [
          // 1. EFECTO PARALLAX: Encabezado que se encoge
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            backgroundColor: guindaUTM,
            iconTheme: const IconThemeData(color: cremaUTM),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.lugar['nombre'],
                style: const TextStyle(
                  color: cremaUTM,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              // Usamos el widget inteligente para la portada
              background: galeria.isNotEmpty
                  ? _buildAdaptiveImage(galeria[0], fit: BoxFit.cover)
                  : Container(color: guindaUTM),
            ),
          ),

          // 2. CONTENIDO DE LA PANTALLA
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Asistente y Subtítulo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.lugar['subtitulo'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black.withValues(alpha: 0.6),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      BotonAudioAnimado(
                        onTap: () {
                          flutterTts.stop();
                          _preguntarIdioma(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Descripción
                  Text(
                    widget.lugar['descripcion'],
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // --- CARRUSEL DE IMÁGENES ---
                  if (galeria.length > 1) ...[
                    const Text(
                      'Galería',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: guindaUTM,
                      ),
                    ),
                    const SizedBox(height: 15),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 200.0,
                        enlargeCenterPage: true,
                        autoPlay: true,
                      ),
                      items: galeria.map((path) {
                        return Builder(
                          builder: (BuildContext context) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              // Widget inteligente para el carrusel
                              child: _buildAdaptiveImage(
                                path,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // --- BOTÓN VISTA 360 ---
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _abrirVisor360,
                      icon: const Icon(Icons.threed_rotation),
                      label: const Text(
                        'Explorar Lugar en 360°',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: doradoUTM,
                        foregroundColor: guindaUTM,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),


                  // --- BOTÓN DE ACTIVIDAD ESPECÍFICO PARA SERVICIOS ESCOLARES ---
if (widget.lugar['nombre'] == "Servicios Escolares")
  Container(
    width: double.infinity,
    margin: const EdgeInsets.only(top: 20),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: doradoUTM.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: doradoUTM, width: 1.5),
    ),
    child: Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videogame_asset, color: guindaUTM, size: 28),
            SizedBox(width: 10),
            Text(
              'Actividad Disponible',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: guindaUTM,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const RallyGameScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: guindaUTM,
            foregroundColor: cremaUTM,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            '🎮 ¡Iniciar juego de Servicios!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  ),

                  // --- BOTÓN DE JUEGO (Si aplica) ---
                  if (widget.lugar['tieneJuego'] == true)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: doradoUTM.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: doradoUTM, width: 1.5),
                      ),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.videogame_asset,
                                color: guindaUTM,
                                size: 28,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Actividad Disponible',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: guindaUTM,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CustomLoaderScreen(
                                        textoCarga: 'Preparando Juego...',
                                        siguientePantalla: TriviaScreen(),
                                      ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: guindaUTM,
                              foregroundColor: cremaUTM,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              '🎮 ¡Jugar Trivia Tech!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),


                  // --- BOTÓN IR A LA CAFETERÍA ---
                if (widget.lugar['nombre'] == "Cafetería Grande")
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            // Asegúrate de que la clase en cafe_screen.dart se llame CafeScreen
                            builder: (context) => const CafeScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.local_cafe),
                      label: const Text(
                        'Visitar la Cafetería',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.brown, // Un color ad hoc para el café ☕
                        foregroundColor: cremaUTM,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40), // Espacio final
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
