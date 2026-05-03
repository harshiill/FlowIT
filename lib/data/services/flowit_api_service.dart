import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/device_data.dart';

class FlowItApiService {
  FlowItApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<DeviceData> fetchData(String baseUrl) async {
    final response = await _client.get(Uri.parse('$baseUrl/data')).timeout(const Duration(seconds: 2));
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch /data: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return DeviceData.fromJson(decoded);
  }

  Future<void> setParams(String baseUrl, Map<String, dynamic> payload) async {
    for (final entry in payload.entries) {
      final url = Uri.parse('$baseUrl/setParam?key=${entry.key}&val=${entry.value}');
      final response = await _client.get(url);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Failed to set param ${entry.key}: ${response.statusCode}');
      }
    }
  }

  Future<void> calibrate(String baseUrl) => _getNoBody(baseUrl, '/calibrate');

  Future<void> reset(String baseUrl) => _getNoBody(baseUrl, '/reset');

  Future<void> manualToggle(String baseUrl) => _getNoBody(baseUrl, '/manualToggle');

  Future<void> startDispense(String baseUrl) => _getNoBody(baseUrl, '/startDispense');

  Future<void> stopDispense(String baseUrl) => _getNoBody(baseUrl, '/stopDispense');

  Future<void> _getNoBody(String baseUrl, String path) async {
    final response = await _client.get(Uri.parse('$baseUrl$path'));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Action failed at $path: ${response.statusCode}');
    }
  }

  void dispose() {
    _client.close();
  }
}
