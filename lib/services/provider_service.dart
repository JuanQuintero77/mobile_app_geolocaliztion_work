import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/worker.dart';

class ProviderService {
  Future<List<Worker>> fetchNearby({
    required double lat,
    required double lng,
    int radiusM = 5000,
  }) async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/providers/nearby'
      '?lat=$lat&lng=$lng&radius_m=$radiusM',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Error del servidor: ${response.statusCode}');
    }

    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((e) => Worker.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> createProvider({
    required String name,
    required String trade,
    required String description,
    required double lat,
    required double lng,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/providers');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'trade': trade,
        'description': description,
        'lat': lat,
        'lng': lng,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }
}