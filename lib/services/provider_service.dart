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
}