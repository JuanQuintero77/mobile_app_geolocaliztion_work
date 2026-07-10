import 'package:latlong2/latlong.dart';

class Worker {
  final int id;
  final String name;
  final String trade;
  final String description;
  final LatLng location;
  final double distanceM;

  const Worker({
    required this.id,
    required this.name,
    required this.trade,
    required this.description,
    required this.location,
    required this.distanceM,
  });

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      id: json['id'] as int,
      name: json['name'] as String,
      trade: json['trade'] as String,
      description: json['description'] as String,
      location: LatLng(
        (json['lat'] as num).toDouble(),
        (json['lng'] as num).toDouble(),
      ),
      distanceM: (json['distance_m'] as num).toDouble(),
    );
  }
}