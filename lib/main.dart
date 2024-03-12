import 'package:flutter/material.dart';
import 'package:fp_thuexe/pages/ProductCar.dart';
import 'package:fp_thuexe/pages/ProductElectricCar.dart';
import 'package:fp_thuexe/shared/widgets/BottomBar.dart';

void main() {
  runApp(MaterialApp(
    title: "Thuê xe",
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: Scaffold(
      bottomNavigationBar: BottomBar(),
    ),
  ));
}
