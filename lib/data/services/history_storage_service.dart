import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/history_entry.dart';

class HistoryStorageService {
  static const _historyKey = 'flowit_history';
  static const _baseUrlKey = 'flowit_base_url';

  Future<List<SessionEntry>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_historyKey);
    if (raw == null || raw.isEmpty) return [];

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => SessionEntry.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<void> saveHistory(List<SessionEntry> history) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(history.map((e) => e.toJson()).toList(growable: false));
    await prefs.setString(_historyKey, encoded);
  }

  Future<String?> loadBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_baseUrlKey);
  }

  Future<void> saveBaseUrl(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_baseUrlKey, value);
  }
}
