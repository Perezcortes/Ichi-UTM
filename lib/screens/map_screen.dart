import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para cargar la imagen
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' hide Size;
import 'game_loader_screen.dart';
import '../utils/constants.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapboxMap? mapboxMap;
  PointAnnotationManager? pointAnnotationManager;

  void _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    _agregarPines();
  }

  Future<void> _agregarPines() async {
    final ByteData bytesImagen = await rootBundle.load(
      'assets/images/punto.png',
    );
    final Uint8List datosImagen = bytesImagen.buffer.asUint8List();

    // 3. Creamos el manejador de Puntos
    pointAnnotationManager = await mapboxMap?.annotations
        .createPointAnnotationManager();

    // 4. Configuramos el Pin (PointAnnotationOptions)
    final opcionesPin = PointAnnotationOptions(
      // Coordenadas del Instituto de Computación
      geometry: Point(
        coordinates: Position(-97.80494287579597, 17.828091721755126),
      ),

      image: datosImagen,

      // Ajuste de tamaño
      iconSize: 0.3,
      iconAnchor: IconAnchor.BOTTOM,
    );

    // Dibujamos el pin
    await pointAnnotationManager?.create(opcionesPin);

    // Activamos el toque
    pointAnnotationManager?.addOnPointAnnotationClickListener(
      PinClickListener(() {
        _mostrarDetalleEdificio(context);
      }),
    );
  }

  // PANEL INFERIOR (BOTTOM SHEET)
  void _mostrarDetalleEdificio(BuildContext context) {
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
              const Text(
                'Instituto de Computación',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: guindaUTM,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Sede de Ing. en Computación e Ing. en Software',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withValues(alpha: 0.6),
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Aquí se forman los futuros desarrolladores y líderes en tecnología. Cuenta con laboratorios de última generación equipados para el desarrollo de software, redes y hardware avanzado.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),
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
                    const SizedBox(height: 10),
                    const Text(
                      '¿Crees que conoces la historia del software y de este edificio? ¡Demuéstralo!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // 1. Cerramos el panel inferior (Bottom Sheet)
                        Navigator.pop(context);
                        // 2. Navegamos a la pantalla de carga animada
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const GameLoaderScreen(),
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
      body: MapWidget(
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
    );
  }
}

class PinClickListener extends OnPointAnnotationClickListener {
  final VoidCallback onTap;

  PinClickListener(this.onTap);

  @override
  bool onPointAnnotationClick(PointAnnotation annotation) {
    onTap();
    return true;
  }
}
