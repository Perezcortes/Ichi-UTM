import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' hide Size;
import '../utils/constants.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapboxMap? mapboxMap;

  void _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
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
          center: Point(coordinates: Position(-97.803579, 17.827274)),
          zoom: 16.5,
          pitch: 60.0,
        ),
      ),
    );
  }
}
