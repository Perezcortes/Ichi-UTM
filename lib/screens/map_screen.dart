import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' hide Size;
import 'package:flutter_tts/flutter_tts.dart';

import '../widgets/custom_loader_screen.dart';
import '../widgets/boton_audio_animado.dart';
import '../data/lugares_utm.dart';
import '../games/trivia_jose/trivia_screen.dart';
import '../utils/constants.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapboxMap? mapboxMap;
  PointAnnotationManager? pointAnnotationManager;
  Map<String, Map<String, dynamic>> pinesDibujados = {};

  FlutterTts flutterTts = FlutterTts();

  Future<void> _reproducirAudio(String texto, String codigoIdioma) async {
    await flutterTts.setLanguage(codigoIdioma);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(texto);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  void _preguntarIdioma(BuildContext context, Map<String, dynamic> lugar) {
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
            'El Tapacaminos leerá la información de este lugar para ti.',
            style: TextStyle(color: Colors.black87),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _reproducirAudio(lugar['descripcion'], 'es-MX');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: guindaUTM,
                foregroundColor: cremaUTM,
                elevation: 3,
              ),
              child: const Text(
                'Español',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                String textoEn =
                    lugar['descripcion_en'] ??
                    "English translation coming soon.";
                _reproducirAudio(textoEn, 'en-US');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: doradoUTM,
                foregroundColor: guindaUTM,
                elevation: 3,
              ),
              child: const Text(
                'English',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    _agregarPinesMasiamente();
  }

  Future<void> _agregarPinesMasiamente() async {
    final ByteData bytesImagen = await rootBundle.load(
      'assets/images/punto.png',
    );
    final Uint8List datosImagen = bytesImagen.buffer.asUint8List();

    pointAnnotationManager = await mapboxMap?.annotations
        .createPointAnnotationManager();

    // Aquí usamos listaLugaresUTM que viene del nuevo archivo
    for (var lugar in listaLugaresUTM) {
      final opcionesPin = PointAnnotationOptions(
        geometry: Point(coordinates: Position(lugar['lng'], lugar['lat'])),
        image: datosImagen,
        iconSize: 0.3,
        iconAnchor: IconAnchor.BOTTOM,
      );

      final annotation = await pointAnnotationManager?.create(opcionesPin);

      if (annotation != null) {
        pinesDibujados[annotation.id] = lugar;
      }
    }

    pointAnnotationManager?.addOnPointAnnotationClickListener(
      PinClickListener((PointAnnotation annotationClicked) {
        final lugarSeleccionado = pinesDibujados[annotationClicked.id];
        if (lugarSeleccionado != null) {
          _mostrarDetalleEdificio(context, lugarSeleccionado);
        }
      }),
    );
  }

  void _mostrarDetalleEdificio(
    BuildContext context,
    Map<String, dynamic> lugar,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: cremaUTM,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lugar['nombre'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: guindaUTM,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          lugar['subtitulo'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black.withValues(alpha: 0.6),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  BotonAudioAnimado(
                    onTap: () {
                      flutterTts.stop();
                      _preguntarIdioma(context, lugar);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                lugar['descripcion'],
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),
              if (lugar['tieneJuego'] == true)
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
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: guindaUTM,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '¡Demuestra tus conocimientos en este minijuego interactivo!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const CustomLoaderScreen(
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
                          elevation: 5,
                        ),
                        child: const Text(
                          '🎮 ¡Jugar Ahora!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ichi UTM - Campus',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: guindaUTM,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          MapWidget(
            key: const ValueKey("mapWidget"),
            onMapCreated: _onMapCreated,
            styleUri: "mapbox://styles/perezcortes/cmn2hhkxd000901qe8f5m02s2",
            cameraOptions: CameraOptions(
              center: Point(
                coordinates: Position(-97.80494287579597, 17.828091721755126),
              ),
              zoom: 16.5,
              pitch: 60.0,
            ),
          ),
          Positioned(
            bottom: 20,
            right: 15,
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      '¡Hola! Soy tu asistente Pu\'ujuy. Pronto te hablaré en Mixteco.',
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: cremaUTM,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: doradoUTM, width: 2),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/ave.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PinClickListener extends OnPointAnnotationClickListener {
  final Function(PointAnnotation) onTap;
  PinClickListener(this.onTap);
  @override
  bool onPointAnnotationClick(PointAnnotation annotation) {
    onTap(annotation);
    return true;
  }
}
