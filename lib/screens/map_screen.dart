import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' hide Size;
import 'package:permission_handler/permission_handler.dart';

import '../data/lugares_utm.dart';
import 'lugar_detalle_screen.dart';
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

  void _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    _agregarPinesMasiamente();
    _habilitarMiUbicacion();
  }

  // --- GPS ---
  Future<void> _habilitarMiUbicacion() async {
    // 1. Pedimos permiso al usuario
    var status = await Permission.locationWhenInUse.request();

    if (status.isGranted) {
      // 2. Si nos da permiso, encendemos el "monito" (Location Puck)
      mapboxMap?.location.updateSettings(
        LocationComponentSettings(
          enabled: true, // Muestra el monito
          pulsingEnabled: true, // Activa el círculo de radar animado
          pulsingMaxRadius: 30.0, // Qué tan grande se hace el radar
        ),
      );
    } else {
      // Si rechaza el permiso, le avisamos
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Para ver tu ubicación en el campus, necesitamos acceso al GPS.',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _agregarPinesMasiamente() async {
    final ByteData bytesImagen = await rootBundle.load(
      'assets/images/punto.png',
    );
    final Uint8List datosImagen = bytesImagen.buffer.asUint8List();

    pointAnnotationManager = await mapboxMap?.annotations
        .createPointAnnotationManager();

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

    pointAnnotationManager?.tapEvents(
      onTap: (PointAnnotation annotationClicked) {
        final lugarSeleccionado = pinesDibujados[annotationClicked.id];

        if (lugarSeleccionado != null) {
          _mostrarDetalleEdificio(context, lugarSeleccionado);
        }
      },
    );
  }

  void _mostrarDetalleEdificio(
    BuildContext context,
    Map<String, dynamic> lugar,
  ) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) =>
            LugarDetalleScreen(lugar: lugar),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero; // ¡CORREGIDO!
          const curve = Curves.easeOutQuart;

          // ¡CORREGIDO EL TIPO DE DATO! (Tween<Offset>)
          var tween = Tween<Offset>(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. EL TRUCO: Permitir que el contenido (mapa/body) suba hasta el techo de la pantalla
      extendBodyBehindAppBar: true,
      backgroundColor: cremaUTM,

      // 2. EL APPBAR ESMERILADO (Glassmorphism)
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70), // Un poco más alta
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05), // Sombra muy sutil
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          // ClipRRect para redondear el efecto de desenfoque
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
            child: BackdropFilter(
              // EL EFECTO MÁGICO DE DESENFOQUE
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AppBar(
                title: const Text(
                  'Ichi UTM - Campus',
                  style: TextStyle(
                    color: guindaUTM, // <-- TEXTO GUINDA SOBRE FONDO BLANCO
                    fontWeight: FontWeight.w900, // Letra muy gruesa
                    fontSize: 22,
                    letterSpacing: -0.5,
                  ),
                ),
                // Fondo blanco translúcido
                backgroundColor: Colors.white.withValues(alpha: 0.7),
                elevation: 0, // Quitamos la elevación por defecto
                centerTitle: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                // Íconos en guinda
                iconTheme: const IconThemeData(color: guindaUTM),
              ),
            ),
          ),
        ),
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
            bottom: 120,
            right: 15,
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      '¡Hola! Soy tu asistente Tapacaminos. Pronto te hablaré en Mixteco.',
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
