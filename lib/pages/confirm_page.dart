import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_zalopay_sdk/flutter_zalopay_sdk.dart';
import 'package:fp_thuexe/models/Vehicle.dart';
import 'package:fp_thuexe/pages/success_page.dart';
import 'package:fp_thuexe/services/ImageService.dart';
import 'package:fp_thuexe/services/UserService.dart';
import 'package:intl/intl.dart';

import '../models/User.dart';
import '../services/AuthService.dart';
import '../services/BookingService.dart';

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

  // Initialize _selectedDateTime1 to tomorrow
  DateTime _selectedDateTime1 = DateTime.now().add(Duration(days: 1));

  // Initialize _selectedDateTime2 to the day after tomorrow
  DateTime _selectedDateTime2 = DateTime.now().add(Duration(days: 2));
  String? _selectedPaymentMethod = 'Tiền mặt';

  final List<String> _paymentMethods = [
    'ZaloPay',
    'Tiền mặt',
  ];

  _ConfirmPageState(this._vehicle);

  @override
  void initState() {
    super.initState();
    _user = User.unLoadedUser();
    _userOwner = User.unLoadedUser();
    _startTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      var user = await AuthService.getUser();
      if (user != null && mounted) {
        setState(() {
          _user = user;
        });
        var userOwner = await UserService.getUserById(_vehicle.ownerId);
        if (userOwner != null && mounted) {
          setState(() {
            _userOwner = userOwner;
          });
          _stopTimer();
        }
      }
    });
  }

  void _stopTimer() {
    if (_timer.isActive) {
      _timer.cancel();
    }
  }

  void _createBooking() async {
    int status = 0;
    String receivingAddress = _user.address;
    int customerId = _user.userId;

    // Calculate the rental cost
    int rentalDays = _selectedDateTime2.difference(_selectedDateTime1).inDays;
    int totalRentalCost = (rentalDays * _vehicle.rentalPrice).toInt();

    // Prevent users from renting their own vehicle
    if (customerId == _userOwner.userId) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Lỗi"),
            content: Text(
                "Bạn không thể thuê xe của chính mình,\n vui lòng chọn xe khác"),
            actions: <Widget>[
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
              ),
            ],
          );
        },
      );
      return;
    }

    // Check if the selected payment method is ZaloPay
    if (_selectedPaymentMethod == 'ZaloPay') {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
        },
      );

      var result = await FlutterZaloPaySdk.payOrder(
          zpToken: 'uUfsWgfLkRLzq6W2uNXTCxrfxs51auny');
      Navigator.pop(context);
      if (result != null) {
        var paymentResult = await FlutterZaloPaySdk.payOrder(
            zpToken: "uUfsWgfLkRLzq6W2uNXTCxrfxs51auny");
        if (paymentResult == FlutterZaloPayStatus.success) {
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Payment Error"),
                content: Text("Failed to process payment. Please try again."),
                actions: <Widget>[
                  TextButton(
                    child: Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          return;
        }
      } else {
        // Payment initiation failed
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Payment Error"),
              content: Text("Failed to initiate payment. Please try again."),
              actions: <Widget>[
                TextButton(
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return; // Exit the function if unable to initiate payment
      }
    }

    Map<String, dynamic> bookingData = {
      'ngay_bat_dau': _selectedDateTime1.toIso8601String(),
      'ngay_ket_thuc': _selectedDateTime2.toIso8601String(),
      'trang_thai_dat_xe': status,
      'dia_chi_nhan_xe': receivingAddress,
      'so_ngay_thue': rentalDays,
      'tong_tien_thue': totalRentalCost,
      'ma_xe': _vehicle.carId,
      'ma_nguoi_dat_xe': customerId,
    };

    try {
      await BookingService.createBooking(bookingData);
      // Navigate to the SuccessPage on successful booking
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SuccessPage()), // Replace SuccessPage() with the actual success page widget
      );
    } catch (e) {
      // Show a dialog on failure
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Failed to create booking. Please try again."),
            actions: <Widget>[
              TextButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
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

    int numberOfDays =
        _selectedDateTime2!.difference(_selectedDateTime1!).inDays;
    numberOfDays = max(1, numberOfDays); // Ensure a minimum of 1 day

    double totalPrice = _vehicle.rentalPrice * numberOfDays;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Card(
        elevation: 4,
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Thông tin thanh toán", // Payment information
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 20),
              _buildInfoTile("Giá thuê mỗi ngày", "${_vehicle.rentalPrice} đ"),
              _buildInfoTile("Số ngày thuê", "$numberOfDays ngày"),
              _buildInfoTile("Tổng giá", "$totalPrice đ"),
              SizedBox(height: 30),
              Text(
                "Chọn phương thức thanh toán",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
                value: _selectedPaymentMethod,
                items: _paymentMethods
                    .map((method) => DropdownMenuItem(
                          value: method,
                          child: Text(method),
                        ))
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPaymentMethod = newValue;
                  });
                },
                hint: Text("Select a payment method"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListTile _buildInfoTile(String title, String trailing) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 16.0),
      ),
      trailing: Text(
        trailing,
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      margin: EdgeInsets.all(12),
      child: MaterialButton(
        onPressed: () {
          _createBooking();
        },
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
