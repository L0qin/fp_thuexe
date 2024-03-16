import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fp_thuexe/models/Vehicle.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ConfirmPage extends StatefulWidget {
  Vehicle vehicle;
  ConfirmPage(this.vehicle, {super.key});
  @override
  State<ConfirmPage> createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Đăng xe",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Container(
          child: Column(
        children: [
          Card(
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(),
            ),
          ),
          Container(
            margin: EdgeInsets.all(12),
            child: MaterialButton(
              onPressed: () {},
              height: 50,
              minWidth: double.infinity,
              color: Colors.teal,
              child: Text(
                "Đăng xe",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          )
        ],
      )),
    );
  }
}
