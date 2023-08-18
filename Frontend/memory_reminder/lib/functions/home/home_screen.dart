import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memory_reminder/core/model/memories_response_model.dart';
import 'package:memory_reminder/core/utils/methods.dart';
import 'package:memory_reminder/core/widgets/base_scaffold.dart';
import 'package:memory_reminder/functions/home/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeBloc homeBloc = HomeBloc();

  @override
  void initState() {
    super.initState();
    homeBloc.fetchMemories();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      isAppBarNeeded: true,
      title: 'Memories',
      isCenterTitle: true,
      isBottomNavRequired: false,
      isFABRequired: true,
      body: RefreshIndicator(
        onRefresh: () async {
          homeBloc.fetchMemories();
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const TextField(),
              StreamBuilder<List<Memories>?>(
                  stream: homeBloc.memoryContorller.stream,
                  builder: (context, memories) {
                    if (memories.hasData) {
                      if (memories.data != null && memories.data == []) {
                        return Center(
                          child: Text(
                            'No Memories Found!',
                            style: TextStyle(
                              fontSize: 24.sp,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(16.sp),
                        itemCount: memories.data?.length,
                        itemBuilder: (context, index) {
                          final mem = memories.data!;
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.all(8.sp),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                mem[index].title!,
                                                style: TextStyle(
                                                  fontSize: 30.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                mem[index].content!,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Image.memory(
                                            base64Decode(mem[index].image!),
                                            width: 80.w,
                                            height: 80.w,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            Methods.getDateFormat(
                                                mem[index].eventDate!),
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              color: Colors.teal,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                              padding: EdgeInsets.all(4.sp),
                                              decoration: BoxDecoration(
                                                color: Colors.teal[400],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(),
                                              ),
                                              child: Text(
                                                mem[index].tag!,
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  }),
            ],
          ),
        ),
      ),
      fab: FloatingActionButton(onPressed: () {}),
    );
  }
}
