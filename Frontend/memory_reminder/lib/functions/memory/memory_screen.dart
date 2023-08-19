import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memory_reminder/core/model/memories_response_model.dart';
import 'package:memory_reminder/core/widgets/base_scaffold.dart';
import 'package:memory_reminder/functions/memory/memory_bloc.dart';

class MemoryScreen extends StatefulWidget {
  final bool isEditing;
  final Memories? memories;
  const MemoryScreen({
    super.key,
    required this.isEditing,
    this.memories,
  });

  @override
  State<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen> {
  MemoryBloc memoryBloc = MemoryBloc();

  @override
  void initState() {
    super.initState();
    memoryBloc =
        MemoryBloc(isEditing: widget.isEditing, memories: widget.memories);
    memoryBloc.init();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(false);
        return Future.value(false);
      },
      child: BaseScaffold(
        isAppBarNeeded: true,
        title: widget.isEditing ? "Edit Memory" : "Add Memory",
        isCenterTitle: true,
        isBottomNavRequired: false,
        isFABRequired: false,
        body: Padding(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              TextField(
                controller: memoryBloc.titleCtrl,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.sp),
                  hintText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.sp),
                  ),
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              TextField(
                controller: memoryBloc.contentCtrl,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.sp),
                  hintText: 'Content',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.sp),
                  ),
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              TextField(
                controller: memoryBloc.emailCtrl,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.sp),
                  hintText: 'User Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.sp),
                  ),
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              InkWell(
                onTap: () => memoryBloc.onDateSelect(context),
                child: TextField(
                  enabled: false,
                  controller: memoryBloc.dateCtrl,
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.sp),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        )),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.sp),
                    hintText: 'Event Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.sp),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              TextField(
                controller: memoryBloc.tagCtrl,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.sp),
                  hintText: 'Tags',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.sp),
                  ),
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              InkWell(
                onTap: () => memoryBloc.onImageSelect(context),
                child: TextField(
                  enabled: false,
                  controller: memoryBloc.imageCtrl,
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.sp),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        )),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.sp),
                    hintText: 'Image',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.sp),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              const Spacer(),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.sp),
                  ))),
                  onPressed: () {
                    if (memoryBloc.isValid(context)) {
                      memoryBloc.onSubmit(context);
                    }
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(fontSize: 20.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
