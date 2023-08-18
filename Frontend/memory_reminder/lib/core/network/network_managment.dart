import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:memory_reminder/core/model/memories_response_model.dart';
import 'package:memory_reminder/core/utils/constatns.dart';

class NetworkManagement {
  static final _ht = http.Client();
  static Future<MemoryResponse?> getMemories() async {
    final resp = await _ht
        .get(Uri.parse("${Constants.baseUrl}/${Constants.fecthMemoryUrl}"));
    return MemoryResponse.fromJson(json.decode(resp.body));
  }
}
