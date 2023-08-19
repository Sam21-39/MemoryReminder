import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memory_reminder/core/model/memories_response_model.dart';
import 'package:memory_reminder/core/utils/methods.dart';
import 'package:memory_reminder/core/widgets/base_scaffold.dart';
import 'package:memory_reminder/functions/home/home_bloc.dart';
import 'package:memory_reminder/functions/memory/memory_screen.dart';

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
    homeBloc.fetchMemories(homeBloc.defaultIndex);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      isAppBarNeeded: true,
      title: 'Memories',
      isCenterTitle: true,
      isBottomNavRequired: false,
      isFABRequired: true,
      actions: [
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          ListTile(
                            selected: homeBloc.defaultIndex == 0,
                            onTap: () {
                              homeBloc.fetchMemories(0);
                              homeBloc.defaultIndex = 0;
                              Navigator.pop(context);
                              EasyLoading.show();
                            },
                            title: Text(
                              'Created Date',
                              style: TextStyle(fontSize: 16.sp),
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            selected: homeBloc.defaultIndex == 1,
                            onTap: () {
                              homeBloc.fetchMemories(1);
                              homeBloc.defaultIndex = 1;
                              Navigator.pop(context);
                              EasyLoading.show();
                            },
                            title: Text(
                              'Event Date',
                              style: TextStyle(fontSize: 16.sp),
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            selected: homeBloc.defaultIndex == 2,
                            onTap: () {
                              homeBloc.fetchMemories(2);
                              homeBloc.defaultIndex = 2;
                              Navigator.pop(context);
                              EasyLoading.show();
                            },
                            title: Text(
                              'Tag',
                              style: TextStyle(fontSize: 16.sp),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: const Icon(Icons.filter_alt_rounded),
        )
      ],
      body: RefreshIndicator(
        onRefresh: () async {
          homeBloc.fetchMemories(homeBloc.defaultIndex);
        },
        child: Container(
          padding: EdgeInsets.all(8.sp),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                StreamBuilder<List<Memories>?>(
                    stream: homeBloc.memoryContorller.stream,
                    builder: (context, memories) {
                      return TextField(
                        enabled: memories.hasData && memories.data!.isNotEmpty,
                        controller: homeBloc.searchCtrl,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 8.sp),
                          hintText: 'Search',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.sp),
                          ),
                        ),
                      );
                    }),
                StreamBuilder<List<Memories>?>(
                    stream: homeBloc.memoryContorller.stream,
                    builder: (context, memories) {
                      if (memories.hasData) {
                        EasyLoading.dismiss();
                        if (memories.data != null && memories.data!.isEmpty) {
                          return Center(
                            child: Text(
                              'No Memories Found!',
                              style: TextStyle(
                                fontSize: 24.sp,
                              ),
                            ),
                          );
                        }

                        final searchList = [];
                        if (homeBloc.searchCtrl.text.isNotEmpty) {
                          searchList.addAll(memories.data!
                              .where((e) => homeBloc.searchCtrl.text
                                  .toLowerCase()
                                  .contains(e.tag!.toLowerCase()))
                              .toList());
                        } else {
                          searchList.clear();
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(8.sp),
                          itemCount: searchList.isEmpty
                              ? memories.data!.length
                              : searchList.length,
                          itemBuilder: (context, index) {
                            final mem = searchList.isEmpty
                                ? memories.data!
                                : searchList;

                            return GestureDetector(
                              onTap: () async {
                                final isRefreshing = await Navigator.of(context)
                                    .push(MaterialPageRoute(
                                  builder: (context) => MemoryScreen(
                                    isEditing: true,
                                    memories: mem[index],
                                  ),
                                ));

                                if (isRefreshing) {
                                  homeBloc.fetchMemories(homeBloc.defaultIndex);
                                  EasyLoading.show();
                                }
                              },
                              child: Container(
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
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    mem[index].content!,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                        BorderRadius.circular(
                                                            8),
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
      ),
      fab: FloatingActionButton(
          child: const Icon(Icons.cloud),
          onPressed: () async {
            final isRefreshing =
                await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const MemoryScreen(isEditing: false),
            ));

            if (isRefreshing) {
              homeBloc.fetchMemories(homeBloc.defaultIndex);
              EasyLoading.show();
            }
          }),
    );
  }
}
