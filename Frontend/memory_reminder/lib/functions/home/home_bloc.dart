import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:memory_reminder/core/model/memories_response_model.dart';
import 'package:memory_reminder/core/network/network_managment.dart';

class HomeBloc {
  final memoryContorller = StreamController<List<Memories>?>.broadcast();
  final searchCtrl = TextEditingController();
  int defaultIndex = 0;
  void fetchMemories(int index) async {
    try {
      final response = await NetworkManagement.getMemories();
      if (index == 1) {
        response?.result!.sort((a, b) => b.eventDate!.compareTo(a.eventDate!));
      } else if (index == 2) {
        response?.result!.sort((a, b) => b.tag!.compareTo(a.tag!));
      }
      memoryContorller.sink.add(response?.result);
    } catch (e) {
      memoryContorller.sink.add([]);
    }
  }
}
