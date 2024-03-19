import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fp_thuexe/models/Vehicle.dart';

import '../models/User.dart';
import '../services/AuthService.dart';

class ConfirmPage extends StatefulWidget {
  Vehicle vehicle;

  ConfirmPage(this.vehicle, {Key? key}) : super(key: key);

  @override
  State<ConfirmPage> createState() => _ConfirmPageState(vehicle);
}

class _ConfirmPageState extends State<ConfirmPage> {
  late Timer _timer;
  late User _user;
  Vehicle _vehicle;

  _ConfirmPageState(this._vehicle);

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      AuthService.getUser().then((user) {
        if (user != null) {
          setState(() {
            _user = user;
          });
          _stopTimer();
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Xác nhận thuê",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 10.0),
          _buildRentingInfoCard(),
          SizedBox(height: 10.0),
          _buildProductInfoCard(),
          SizedBox(height: 10.0),
          _buildPaymentInfoCard(),
          SizedBox(height: 10.0),
          _buildButton(),
        ],
      ),
    );
  }

  Widget _buildRentingInfoCard() {
    return Container(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Thông tin thuê xe", // Car details
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfoCard() {
    return Container(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sản phẩm thuê", // Car details
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentInfoCard() {
    return Container(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Thông tin thanh toán", // Car details
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      margin: EdgeInsets.all(12),
      child: MaterialButton(
        onPressed: () {},
        height: 50,
        minWidth: double.infinity,
        color: Colors.teal,
        child: Text(
          "Thuê",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
    );
  }
}
