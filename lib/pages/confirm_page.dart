import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fp_thuexe/models/Vehicle.dart';
import 'package:fp_thuexe/services/ImageService.dart';
import 'package:fp_thuexe/services/UserService.dart';
import 'package:intl/intl.dart';

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
  late User _userOwner;
  Vehicle _vehicle;
  late String imgURL;
  DateTime? _selectedDateTime1;
  DateTime? _selectedDateTime2;

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
          UserService.getUserById(_vehicle.carId).then((userOwner) {
            if (userOwner != null) {
              setState(() {
                _userOwner = userOwner;
              });
              _stopTimer();
            }
          });
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
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildRentingInfoCard(),
            SizedBox(height: 10.0),
            _buildProductInfoCard(),
            SizedBox(height: 10.0),
            _buildPaymentInfoCard(),
            SizedBox(height: 10.0),
            _buildButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildRentingInfoCard() {
    return Container(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.all(5),
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
              SizedBox(height: 10.0),
              InkWell(
                onTap: () {},
                splashColor: Colors.white12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[300],
                      // Optional: Set a background color
                      child: Image.network(
                        _userOwner.profilePicture,
                        // Use the function directly
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.teal,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              _userOwner == null ? "..." : _userOwner.fullName,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.pin_drop),
                                Text(
                                  _userOwner == null
                                      ? "..."
                                      : _userOwner.address, // Car details
                                  style: TextStyle(
                                      fontSize: 15.0, color: Colors.teal),
                                ),
                              ],
                            )
                          ],
                        )),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Stack(
                alignment: Alignment.center,
                children: [
                  Divider(),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: const Icon(
                      Icons.arrow_downward,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              InkWell(
                onTap: () {},
                splashColor: Colors.white12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[300],
                      // Optional: Set a background color
                      child: Image.network(
                        _user.profilePicture,
                        // Use the function directly
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.teal,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              _user.fullName,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.pin_drop),
                                Text(
                                  _user.address, // Car details
                                  style: TextStyle(
                                      fontSize: 15.0, color: Colors.teal),
                                ),
                              ],
                            )
                          ],
                        )),
                  ],
                ),
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
        margin: EdgeInsets.all(5),
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
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          Colors.grey[300], // Optional: Set a background color
                    ),
                    child: FutureBuilder<String>(
                      future: ImageService.getVehicleMainImageURLById(
                          _vehicle.carId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Icon(
                            Icons.directions_car,
                            size: 50,
                            color: Colors.teal,
                          );
                        } else if (snapshot.hasData) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              snapshot.data!,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                Icons.directions_car,
                                size: 50,
                                color: Colors.teal,
                              ),
                              fit: BoxFit.cover,
                            ),
                          );
                        } else {
                          return Container(); // Placeholder widget if no data
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // Align text to the left
                      children: [
                        Text(
                          _vehicle == null ? "..." : _vehicle.carName,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          _vehicle == null
                              ? "..."
                              : "${_vehicle.manufacturer}, ${_vehicle.model}",
                          style: TextStyle(fontSize: 15.0, color: Colors.teal),
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          child: Text(
                            _vehicle == null
                                ? "..."
                                : "${_vehicle.description.length > 30 ? _vehicle.description.substring(0, 30) + '...' : _vehicle.description}",
                            // Trim description to shorter length
                            style:
                                TextStyle(fontSize: 15.0, color: Colors.teal),
                            overflow: TextOverflow.ellipsis,
                            // Handle overflow with ellipsis
                            maxLines: 1, // Display only 1 line
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Container(
                height: 10,
              ),
              _cardTimeWidget(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentInfoCard() {
    if (_selectedDateTime1 == null ||
        _selectedDateTime2 == null ||
        _vehicle == null) {
      return Container(); // Return an empty container if dates or vehicle are not selected
    }

    // Calculate the number of days between selected dates
    int numberOfDays =
        _selectedDateTime2!.difference(_selectedDateTime1!).inDays;
    numberOfDays = max(1, numberOfDays); // Ensure minimum of 1 day

    // Calculate total price
    double totalPrice = _vehicle.rentalPrice * numberOfDays;

    return Container(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.all(5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Thông tin thanh toán", // Payment information
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text(
                  "Giá thuê mỗi ngày",
                  style: TextStyle(fontSize: 16.0),
                ),
                trailing: Text(
                  "${_vehicle.rentalPrice} đ",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              ListTile(
                title: Text(
                  "Số ngày thuê",
                  style: TextStyle(fontSize: 16.0),
                ),
                trailing: Text(
                  "$numberOfDays ngày",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              ListTile(
                title: Text(
                  "Tổng giá",
                  style: TextStyle(fontSize: 16.0),
                ),
                trailing: Text(
                  "$totalPrice đ",
                  style: TextStyle(fontSize: 16.0),
                ),
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

  Widget _cardTimeWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Stack(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: InkWell(
                  onTap: () => _showDateTimePicker(context, 1),
                  splashColor: Colors.teal,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    constraints: BoxConstraints(minWidth: 150),
                    // Adjust the minimum width as needed
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              _selectedDateTime1 == null
                                  ? DateFormat('dd').format(DateTime.now())
                                  : DateFormat('dd')
                                      .format(_selectedDateTime1!),
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _selectedDateTime1 == null
                                  ? DateFormat('yyyy-MM-dd')
                                      .format(DateTime.now())
                                  : DateFormat('yyyy-MM-dd')
                                      .format(_selectedDateTime1!),
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              _selectedDateTime1 == null
                                  ? DateFormat('HH:mm').format(DateTime.now())
                                  : DateFormat('HH:mm')
                                      .format(_selectedDateTime1!),
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 35,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
              Expanded(
                child: InkWell(
                  onTap: () => _showDateTimePicker(context, 2),
                  splashColor: Colors.teal,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    constraints: BoxConstraints(minWidth: 150),
                    // Adjust the minimum width as needed
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              _selectedDateTime2 == null
                                  ? DateFormat('dd').format(DateTime.now())
                                  : DateFormat('dd')
                                      .format(_selectedDateTime2!),
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _selectedDateTime2 == null
                                  ? DateFormat('yyyy-MM-dd')
                                      .format(DateTime.now())
                                  : DateFormat('yyyy-MM-dd')
                                      .format(_selectedDateTime2!),
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              _selectedDateTime2 == null
                                  ? DateFormat('HH:mm').format(DateTime.now())
                                  : DateFormat('HH:mm')
                                      .format(_selectedDateTime2!),
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showDateTimePicker(BuildContext context, int index) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          if (index == 1) {
            _selectedDateTime1 = selectedDateTime;
          } else if (index == 2) {
            _selectedDateTime2 = selectedDateTime;
          }
        });
      }
    }
  }
}
