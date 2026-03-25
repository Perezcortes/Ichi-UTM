import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  MapboxOptions.setAccessToken(dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ichi UTM',
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapboxMap? mapboxMap;
  CircleAnnotationManager? circleAnnotationManager;

  final Color guindaUTM = const Color(0xFF4A1110);

  void _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;

    circleAnnotationManager = await mapboxMap.annotations
        .createCircleAnnotationManager();

    _agregarPuntoDeInteres(
      longitud: -97.800065, // Ajustaremos estas coordenadas después
      latitud: 17.829847,
      idLugar: "instituto_computacion",
    );
  }

  // Función auxiliar para crear puntos fácilmente
  void _agregarPuntoDeInteres({
    required double longitud,
    required double latitud,
    required String idLugar,
  }) {
    circleAnnotationManager?.create(
      CircleAnnotationOptions(
        geometry: Point(coordinates: Position(longitud, latitud)),
        circleColor: guindaUTM.value, // Color Guinda
        circleRadius: 10.0, // Tamaño del círculo
        circleStrokeWidth: 3.0, // Grosor del borde
        circleStrokeColor: 0xFFD4A336, // Color Dorado para el borde
      ),
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
          center: Point(coordinates: Position(-97.800065, 17.829847)),
          zoom: 15.5,
          pitch: 45.0,
        ),
      ),
    );
  }
}
