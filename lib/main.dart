import 'package:flutter/material.dart';
import 'package:fp_thuexe/PostCar.dart';
import 'core.dart';
import 'search.dart';

void main() {
  // runApp(Search());
  runApp(MaterialApp(
    title: 'My app', // used by the OS task switcher
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  static const title = 'Thuê xe';

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyApp.title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        //--------------------------------------------------------------------------------------------------------------
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey,Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.3, 0.7],
            ),
          ),

          child: Container(
          ),
        ),
        //--------------------------------------------------------------------------------------------------------------
        bottomNavigationBar: const BottomBar(),
      ),
    );
  }
}
