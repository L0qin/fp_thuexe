import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fp_thuexe/services/UserService.dart';
import 'package:fp_thuexe/shared/widgets/BottomBar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   int _lastNotificationCount=0;

  @override
  void initState() {
    super.initState();
    // Timer.periodic(Duration(seconds: 1), (timer) async {
    //   try {
    //     int newCount = await UserService.getUserUnreadNotificationCount();
    //     print("Fetched new count: $_lastNotificationCount");
    //     if (newCount != _lastNotificationCount) {
    //       setState(() {
    //         _lastNotificationCount = 100;
    //       });
    //     }
    //   } catch (e) {
    //     print("Error fetching count: $e");
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Thuê xe",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        bottomNavigationBar: BottomBar( _lastNotificationCount),
      ),
    );
  }
}
