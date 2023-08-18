import 'dart:async';

import 'package:memory_reminder/core/model/memories_response_model.dart';
import 'package:memory_reminder/core/network/network_managment.dart';

class HomeBloc {
  final memoryContorller = StreamController<List<Memories>?>.broadcast();

  void fetchMemories() async {
    final response = await NetworkManagement.getMemories();
    memoryContorller.sink.add(response?.result);
  }
}
