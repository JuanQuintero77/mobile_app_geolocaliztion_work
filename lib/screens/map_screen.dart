import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../models/worker.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng? _userLocation;
  List<Worker> _workers = [];
  String _status = 'Obteniendo ubicación...';

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _status = 'Activa la ubicación del dispositivo.');
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() => _status = 'Permiso de ubicación denegado.');
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      final userLatLng = LatLng(position.latitude, position.longitude);
      setState(() {
        _userLocation = userLatLng;
        _workers = _sampleWorkersAround(userLatLng);
      });
      _mapController.move(userLatLng, 15);
    } catch (e) {
      setState(() => _status = 'No se pudo obtener la ubicación: $e');
    }
  }

  // Datos de ejemplo alrededor del usuario. Se reemplazará por el backend.
  List<Worker> _sampleWorkersAround(LatLng c) {
    return [
      Worker(
        name: 'María Restrepo',
        trade: 'Costurera',
        description: 'Arreglos de ropa y confección a medida.',
        location: LatLng(c.latitude + 0.004, c.longitude + 0.003),
      ),
      Worker(
        name: 'Carlos Gómez',
        trade: 'Electricista',
        description: 'Instalaciones y reparaciones eléctricas.',
        location: LatLng(c.latitude - 0.003, c.longitude + 0.005),
      ),
      Worker(
        name: 'Taller El Buen Corte',
        trade: 'Carpintería',
        description: 'Muebles a medida y reparaciones en madera.',
        location: LatLng(c.latitude + 0.002, c.longitude - 0.004),
      ),
      Worker(
        name: 'Ana Valencia',
        trade: 'Peluquería',
        description: 'Corte y peinado a domicilio.',
        location: LatLng(c.latitude - 0.005, c.longitude - 0.002),
      ),
    ];
  }

  void _showWorkerSheet(Worker worker) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(worker.name,
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(worker.trade,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    )),
            const SizedBox(height: 12),
            Text(worker.description),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Contactando a ${worker.name}...')),
                  );
                },
                icon: const Icon(Icons.chat),
                label: const Text('Contactar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Oficios cerca de ti')),
      body: _userLocation == null
          ? Center(child: Text(_status))
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _userLocation!,
                initialZoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.tuempresa.oficios_cerca',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _userLocation!,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.my_location,
                          color: Colors.blue, size: 32),
                    ),
                    ..._workers.map(
                      (w) => Marker(
                        point: w.location,
                        width: 44,
                        height: 44,
                        child: GestureDetector(
                          onTap: () => _showWorkerSheet(w),
                          child: const Icon(Icons.location_pin,
                              color: Colors.red, size: 40),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_userLocation != null) _mapController.move(_userLocation!, 15);
        },
        child: const Icon(Icons.gps_fixed),
      ),
    );
  }
}