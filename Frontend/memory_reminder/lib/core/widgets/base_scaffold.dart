import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseScaffold extends StatefulWidget {
  final bool isAppBarNeeded;
  final Widget body;
  final String title;
  final bool isCenterTitle;
  final bool isBottomNavRequired;
  final Widget? bottomNavBar;
  final bool isFABRequired;
  final FloatingActionButton? fab;
  final List<Widget>? actions;
  const BaseScaffold({
    super.key,
    required this.isAppBarNeeded,
    required this.body,
    required this.title,
    required this.isCenterTitle,
    required this.isBottomNavRequired,
    required this.isFABRequired,
    this.bottomNavBar,
    this.fab,
    this.actions,
  });

  @override
  State<BaseScaffold> createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: widget.isAppBarNeeded
            ? AppBar(
                backgroundColor: Colors.tealAccent,
                foregroundColor: Colors.black87,
                shadowColor: Colors.black,
                elevation: 8,
                centerTitle: widget.isCenterTitle,
                title: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: widget.actions!,
              )
            : null,
        backgroundColor: Colors.white,
        body: StreamBuilder<ConnectivityResult>(
            stream: Connectivity().onConnectivityChanged,
            builder: (context, conn) {
              if (conn.data == ConnectivityResult.wifi ||
                  conn.data == ConnectivityResult.mobile) {
                return widget.body;
              }
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(16.sp),
                  child: Text(
                    'No Internet Connection!',
                    style: TextStyle(
                      fontSize: 30.sp,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }),
        floatingActionButton: widget.isFABRequired ? widget.fab : null,
        bottomNavigationBar:
            widget.isBottomNavRequired ? widget.bottomNavBar : null,
      ),
    );
  }
}
