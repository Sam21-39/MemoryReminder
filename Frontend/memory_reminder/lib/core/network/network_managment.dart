import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:memory_reminder/core/model/memories_add_response.dart';
import 'package:memory_reminder/core/model/memories_request_model.dart';
import 'package:memory_reminder/core/model/memories_response_model.dart';
import 'package:memory_reminder/core/utils/constatns.dart';

import '../model/memory_edit_response_model.dart';

class NetworkManagement {
  static final _ht = http.Client();
  static Future<MemoryResponse?> getMemories() async {
    final resp = await _ht
        .get(Uri.parse("${Constants.baseUrl}/${Constants.fecthMemoryUrl}"));
    return MemoryResponse.fromJson(json.decode(resp.body));
  }

  static Future<MemoryAddRepsonse> addMemories(
      MemoryRequest memoryRequest) async {
    final resp = await _ht.post(
      Uri.parse("${Constants.baseUrl}/${Constants.addToMemoryUrl}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(memoryRequest.toJson()),
    );
    return MemoryAddRepsonse.fromJson(json.decode(resp.body));
  }

  static Future<MemoryEditRepsonse> editMemories(
      MemoryRequest memoryRequest, String id) async {
    final resp = await _ht.put(
      Uri.parse("${Constants.baseUrl}/${Constants.editMemoryUrl}/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(memoryRequest.toJson()),
    );
    return MemoryEditRepsonse.fromJson(json.decode(resp.body));
  }
}
