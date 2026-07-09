import 'package:latlong2/latlong.dart';

class Worker {
  final String name;
  final String trade; // oficio
  final String description;
  final LatLng location;

  const Worker({
    required this.name,
    required this.trade,
    required this.description,
    required this.location,
  });
}