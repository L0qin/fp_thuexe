import 'package:flutter/material.dart';
import 'package:fp_thuexe/pages/home_page.dart';
import 'package:fp_thuexe/shared/widgets/BottomBar.dart';

void main() {
  // runApp(Search());
  runApp(MaterialApp(
    title: "Thuê xe",
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: const Scaffold(
      // bottomNavigationBar: BottomBar(),
    ),
  ));
}
