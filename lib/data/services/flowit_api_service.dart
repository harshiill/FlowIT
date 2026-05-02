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
    final response = await _client.post(
      Uri.parse('$baseUrl/setParam'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to set param: ${response.statusCode}');
    }
  }

  Future<void> calibrate(String baseUrl) => _postNoBody(baseUrl, '/calibrate');

  Future<void> reset(String baseUrl) => _postNoBody(baseUrl, '/reset');

  Future<void> manualToggle(String baseUrl) => _postNoBody(baseUrl, '/manualToggle');

  Future<void> startDispense(String baseUrl) => _postNoBody(baseUrl, '/startDispense');

  Future<void> startVolumeDispense(String baseUrl, double targetLiters) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/dispenseVolume'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'targetVolume': targetLiters}),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to dispense volume: ${response.statusCode}');
    }
  }

  Future<void> stopDispense(String baseUrl) => _postNoBody(baseUrl, '/stopDispense');

  Future<void> _postNoBody(String baseUrl, String path) async {
    final response = await _client.post(Uri.parse('$baseUrl$path'));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Action failed at $path: ${response.statusCode}');
    }
  }

  void dispose() {
    _client.close();
  }
}
