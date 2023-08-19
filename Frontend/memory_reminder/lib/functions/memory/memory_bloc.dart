import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memory_reminder/core/model/memories_request_model.dart';
import 'package:memory_reminder/core/model/memories_response_model.dart';
import 'package:memory_reminder/core/network/network_managment.dart';
import 'package:memory_reminder/core/utils/methods.dart';

class MemoryBloc {
  final bool isEditing;
  final Memories? memories;
  MemoryBloc({this.isEditing = false, this.memories});

  final titleCtrl = TextEditingController();
  final contentCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  final tagCtrl = TextEditingController();
  final imageCtrl = TextEditingController();

  DateTime selectedDate = DateTime.now();
  // ignore: prefer_typing_uninitialized_variables
  var convertedImage;

  init() async {
    if (isEditing) {
      titleCtrl.text = memories!.title!;
      contentCtrl.text = memories!.content!;
      emailCtrl.text = memories!.userEmail!;
      dateCtrl.text = Methods.getDateFormat(memories!.eventDate!);
      tagCtrl.text = memories!.tag!;
      imageCtrl.text = "image.png";
      convertedImage = memories!.image!;
      selectedDate = memories!.eventDate!;
    }
  }

  bool isValid(BuildContext context) {
    if (titleCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Title cannot be empty')));
      return false;
    } else if (contentCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Content cannot be empty')));
      return false;
    } else if (emailCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User Email cannot be empty')));
      return false;
    } else if (dateCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event Date cannot be empty')));
      return false;
    }
    return true;
  }

  onDateSelect(BuildContext context) async {
    final time = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (time == null) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event Date cannot be empty')));
    } else {
      dateCtrl.text = Methods.getDateFormat(time);
      selectedDate = time;
    }
  }

  onImageSelect(BuildContext context) async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img == null) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please select a Image')));
    } else {
      final File file = File(img.path);
      imageCtrl.text = img.name;
      convertedImage = await Methods.imageToBase64Conversion(file);
      // print(convertedImage);
    }
  }

  onSubmit(BuildContext context) async {
    EasyLoading.show();
    final MemoryRequest memoryRequest = MemoryRequest(
      title: titleCtrl.text,
      content: contentCtrl.text,
      userEmail: emailCtrl.text,
      eventDate: selectedDate,
      tag: tagCtrl.text.isEmpty ? null : tagCtrl.text,
      image: convertedImage,
    );

    if (isEditing) {
      try {
        log(memoryRequest.toJson().toString());
        final resp =
            await NetworkManagement.editMemories(memoryRequest, memories!.id!);
        // print(resp.status);
        if (resp.status == "OK") {
          EasyLoading.showSuccess('Success');
          // ignore: use_build_context_synchronously
          Future.delayed(const Duration(milliseconds: 1200))
              .then((value) => Navigator.pop(context, true));
        } else {
          EasyLoading.showError(resp.toString());
        }
      } catch (e) {
        // print(e.toString());
        EasyLoading.showError(e.toString());
      }
    } else {
      try {
        final resp = await NetworkManagement.addMemories(memoryRequest);
        // print(resp.status);
        if (resp.status == "CREATED") {
          EasyLoading.showSuccess('Success');
          // ignore: use_build_context_synchronously
          Future.delayed(const Duration(milliseconds: 1200))
              .then((value) => Navigator.pop(context, true));
        } else {
          EasyLoading.showError(resp.toString());
        }
      } catch (e) {
        // print(e.toString());
        EasyLoading.showError(e.toString());
      }
    }
  }
}
