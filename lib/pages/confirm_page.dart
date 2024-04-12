import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_zalopay_sdk/flutter_zalopay_sdk.dart';
import 'package:fp_thuexe/models/Vehicle.dart';
import 'package:fp_thuexe/pages/success_page.dart';
import 'package:fp_thuexe/services/ImageService.dart';
import 'package:fp_thuexe/services/OtherService.dart';
import 'package:fp_thuexe/services/UserService.dart';
import 'package:intl/intl.dart';

import '../models/User.dart';
import '../models/VehicleBooking.dart';
import '../services/AuthService.dart';
import '../services/BookingService.dart';

class ConfirmPage extends StatefulWidget {
  Vehicle vehicle;

  ConfirmPage(this.vehicle, {Key? key}) : super(key: key);

  @override
  State<ConfirmPage> createState() => _ConfirmPageState(vehicle);
}

class _ConfirmPageState extends State<ConfirmPage> {
  String _deliveryOption = 'Giao xe tận nơi';
  late Timer _timer;
  late User _user;
  late User _userOwner;
  Vehicle _vehicle;
  late String imgURL;
  late TextEditingController tecNotes = TextEditingController();

  DateTime _selectedDateTime1 = DateTime.now().add(Duration(days: 1));

  DateTime _selectedDateTime2 = DateTime.now().add(Duration(days: 2));
  String? _selectedPaymentMethod = 'Thanh toán bằng tiền mặt';

  final List<String> _paymentMethods = [
    'Thanh toán trực tuyến',
    'Thanh toán bằng tiền mặt',
    'Chuyển khoản ngân hàng',
  ];

  var _selectedVoucher;

  void _createBooking() async {
    int customerId = _user.userId;
    String notes = tecNotes.text;
    DateTime startDate = _selectedDateTime1;
    DateTime endDate = _selectedDateTime2;
    int? pickupAddressId =
        1; // Assuming this is obtained elsewhere in your code
    int userId = _user.userId;
    int ownerId = _userOwner.userId;
    int carId = _vehicle.carId;
    int voucherId = _selectedVoucher ?? -1;

    // Check if the user is trying to rent their own vehicle
    if (customerId == _userOwner.userId) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(
                "You cannot rent your own vehicle. Please choose another vehicle."),
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

    // Create a Booking object
    Booking booking = Booking(
      startDate: startDate,
      endDate: endDate,
      pickupAddressId: pickupAddressId,
      totalRental: totalAmount,
      carId: carId,
      userId: userId,
      ownerId: ownerId,
      notes: notes,
      discount: 0,
      delivery: _deliveryOption,
    );

    try {
      bool bookingCreated = await BookingService.createBooking(booking);
      if (bookingCreated) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessPage(),
          ),
        );
      } else {
        throw Exception('The booking could not be created.');
      }
    } catch (e) {
      // Show a dialog on failure
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Failed to create booking. Please try again: $e"),
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
      bottomNavigationBar: _buildButton(),
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
            _buildCommentForm(),
            _buildNotes(),
            _buildPaymentInfoCard(),
            _buildInfoNote1(),
            _buildInfoNote2(),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentForm() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Ghi chú cho chủ xe',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 50,
            ),
            TextButton(onPressed: () {}, child: Text('Gợi ý'))
          ],
        ),
        Card(
          color: Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.all(10),
          child: TextField(
            controller: tecNotes,
            decoration: InputDecoration(
              hintText: 'Nhập nội dung ghi chú',

              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              filled: true, // Đánh dấu có nền
              fillColor: Colors.grey[200], // Màu nền của TextField
            ),
            maxLines: 3,
          ),
        ),
      ],
    );
  }

  Widget _buildNotes() {
    return FutureBuilder<Map<String, dynamic>>(
      future: OtherService.getTerm(5), // Replace '1' with the appropriate id
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while fetching data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final title = snapshot.data?['title'] ?? "";
          final content = snapshot.data?['content'] ?? "";

          return Column(
            children: [
              SizedBox(
                height: 12,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                // Không có khoảng thụt vào
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    // Đặt khoảng lề bên trái là 16
                    child: Icon(Icons.not_listed_location_rounded, size: 25),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          content,
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          );
        }
      },
    );
  }

  Widget _buildInfoNote1() {
    return FutureBuilder<Map<String, dynamic>>(
      future: OtherService.getTerm(3),
      // Assuming 1 is the ID you want to retrieve
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while fetching data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final title = snapshot.data?['title'];
          final content = snapshot.data?['content'];

          return Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(height: 30, thickness: 1),
                Row(
                  children: [
                    Text(
                      title ?? "", // Display title from snapshot data
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.not_listed_location, size: 30),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  content ?? "", // Display content from snapshot data
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildInfoNote2() {
    return FutureBuilder<Map<String, dynamic>>(
      future: OtherService.getTerm(4),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading indicator while waiting for the data
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Display an error message if there's an error
          return Text('Error: ${snapshot.error}');
        } else {
          // Once data is fetched successfully, display it
          final title = snapshot.data?['title'];
          final content = snapshot.data?['content'];

          return Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(height: 30, thickness: 1),
                Row(
                  children: [
                    Text(
                      title ?? "", // Display the title
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.not_listed_location, size: 30),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        content ?? "", // Display the content
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        }
      },
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
              _cardTimeWidget(context),
              Container(
                height: 10,
              ),
// Radio buttons for delivery options
              ListTile(
                title: const Text('Giao xe tận nơi'),
                leading: Radio<String>(
                  value: 'Giao xe tận nơi',
                  groupValue: _deliveryOption,
                  onChanged: (value) {
                    setState(() {
                      _deliveryOption = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Người thuê tới lấy'),
                leading: Radio<String>(
                  value: 'Người thuê tới lấy',
                  groupValue: _deliveryOption,
                  onChanged: (value) {
                    setState(() {
                      _deliveryOption = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isDiscount10Checked = false;
  bool _isCoupon500Checked = false;
  double totalAmount = 0;

// Widget to build the payment information card
  Widget _buildPaymentInfoCard() {
    if (_selectedDateTime1 == null ||
        _selectedDateTime2 == null ||
        _vehicle == null) {
      return Container();
    }

    int numberOfDays =
        _selectedDateTime2!.difference(_selectedDateTime1!).inDays;
    numberOfDays = max(1, numberOfDays);

    double totalPrice = _vehicle.rentalPrice * numberOfDays;
    double sum = totalPrice;
    if (_selectedVoucher == 1) {
      sum -= (sum * 0.1); // Apply a 10% discount
    } else if (_selectedVoucher == 2) {
      sum -= 500;
    }
    double depositAmount = 0.0;
    final requiresDeposit = true;
    if (requiresDeposit) {
      depositAmount = totalPrice - (totalPrice * 0.3);
    }

    double remainingBalance = sum - depositAmount;
    totalAmount = remainingBalance;
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
              Divider(),
              _buildVoucherList(),
              _buildInfoTile("Tổng giá", "$sum đ"),
              if (requiresDeposit) ...[
                _buildInfoTile(
                    "Đặt cọc", "${depositAmount.toStringAsFixed(2)} đ"),
                _buildInfoTile("Số dư còn lại",
                    "${remainingBalance.toStringAsFixed(2)} đ"),
              ],
              Divider(),
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
              SizedBox(height: 20),

              // Hiển thị nút thanh toán
            ],
          ),
        ),
      ),
    );
  }

  var _vouchers;

  Widget _buildVoucherList() {
    return FutureBuilder<Map<int, Map<String, dynamic>>>(
      future: OtherService.getVouchers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading indicator while waiting for the data
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Display an error message if there's an error
          return Text('Error: ${snapshot.error}');
        } else {
          // Once data is fetched successfully, display it
          final vouchers = snapshot.data;
          _vouchers = vouchers;
          return Container(
            child: Column(
              children: [
                Text(
                  "Chọn khuyến mãi (nếu có)",
                  // Promotion selection (if available)
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                if (vouchers != null)
                  Column(
                    children: vouchers.entries.map((entry) {
                      final voucherDetails = entry.value;
                      final description = voucherDetails['mo_ta'];
                      final displayText = "$description";

                      return RadioListTile<int>(
                        title: Text(displayText),
                        value: entry.key,
                        groupValue: _selectedVoucher,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedVoucher = value!;
                          });
                        },
                      );
                    }).toList(),
                  ),
                Divider(),
              ],
            ),
          );
        }
      },
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

  bool _isPolicyAgreed = true;

  Widget _buildButton() {
    return Container(
      margin: EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Prevent unnecessary space
        children: [
          Row(
            children: [
              Checkbox(
                activeColor: Colors.green,
                value: _isPolicyAgreed,
                onChanged: (bool? value) {
                  setState(() {
                    _isPolicyAgreed = value!;
                  });
                },
              ),
              TextButton(
                onPressed: () {
                  // Function to show modal bottom sheet with terms fetched from the server
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return FutureBuilder<Map<String, dynamic>>(
                        future: OtherService.getTerm(2),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text("Error fetching terms"));
                          } else if (snapshot.hasData) {
                            return Container(
                              height: 500, // Set height for bottom sheet
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data!['title'],
                                    // Title from fetched data
                                    style: TextStyle(
                                        color: Colors.teal,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Divider(
                                    color: Colors.teal,
                                    thickness: 2,
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Text(
                                        snapshot.data!['content'],
                                        // Content from fetched data
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.teal)),
                                          child: Text(
                                            "Đóng",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ))
                                    ],
                                  )
                                ],
                              ),
                            );
                          } else {
                            return Center(child: Text("No data"));
                          }
                        },
                      );
                    },
                  );
                },
                child: Text(
                  "Tôi đồng ý với các điều khoản và chính sách",
                  style: TextStyle(
                      fontSize: 14, decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          SizedBox(height: 10), // Add spacing between checkbox and button
          MaterialButton(
            minWidth: double.infinity,
            onPressed: _user.userId == -1
                ? null
                : () async {
                    if (_isPolicyAgreed) {
                      bool isBookable =
                          await BookingService.checkBookable(_user.userId);
                      if (isBookable) {
                        _createBooking(); // Proceed with booking creation
                      } else {
                        // Inform the user they cannot book right now and return to home page
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Bạn không thể đặt thêm xe vì đã có một đặt xe đang chờ xử lý hoặc chưa hoàn thành."),
                            backgroundColor: Colors.red,
                          ),
                        );
                        Navigator.of(context)
                            .pop(); // Assuming you want to pop back to the home page
                      }
                    } else {
                      // Show message or handle user not agreeing
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Vui lòng đồng ý với chính sách trước khi gửi yêu cầu"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
            child: Text('Đặt Xe'),
            color: Colors.teal,
            textColor: Colors.white,
            disabledColor:
                Colors.grey, // Optional: Set a different color when disabled
          ),
        ],
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
