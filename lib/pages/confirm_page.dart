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
  String? _selectedPaymentMethod = 'Thanh toán bằng tiền mặt';

  final List<String> _paymentMethods = [
    'Thanh toán trực tuyến',
    'Thanh toán bằng tiền mặt',
    'Chuyển khoản ngân hàng',
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
    if (_selectedPaymentMethod == 'Thanh toán trực tuyến') {
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
            _buildPaymentInfoCard(),
            _buildInfroNote(),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentForm() {
    String comment = ''; // Biến để lưu trữ nội dung bình luận

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
            onChanged: (value) {
              comment = value;
            },
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
        SizedBox(height: 10),
        // ElevatedButton(
        //   onPressed: () {
        //     // Xử lý khi người dùng nhấn nút gửi bình luận
        //     if (comment.isNotEmpty) {
        //       // Kiểm tra nếu nội dung bình luận không trống
        //       // Thực hiện các hành động khác ở đây, ví dụ: gửi bình luận đến máy chủ
        //       print('Nội dung bình luận: $comment');
        //       // Sau khi xử lý, bạn có thể làm sạch biểu mẫu bằng cách đặt lại giá trị biến comment
        //       comment = '';
        //     }
        //   },
        //   child: Text('Gửi'),
        // ),
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
              child: Text(
                "Giao dịch qua fp_thuexe để chúng tôi bảo vệ bạn tốt nhất trong trường hợp bị huỷ chuyến ngoài ý muốn & phát sinh sự cố có bảo hiểm",
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildInfroNote() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      // Thêm lề cho container
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(height: 30, thickness: 1),
          Row(
            children: [
              Text(
                "Giấy tờ thuê xe",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              Icon(Icons.not_listed_location, size: 30),
            ],
          ),
          SizedBox(height: 8),
          Text(
            "Chọn 1 trong 2 hình thức:",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.insert_drive_file, size: 30),
              SizedBox(width: 10),
              Text(
                "GPLX & CCCD gắn chíp (đối chiếu)",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.insert_drive_file, size: 30),
              SizedBox(width: 10),
              Text(
                "GPLX (đối chiếu) & Passport (giữ lại)",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          Divider(height: 30, thickness: 1),
          Row(
            children: [
              Text(
                "Tài sản thế chấp",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  "30 triệu (tiền mặt/chuyển khoảng cho chủ xe khi nhận xe) hoặc Xe máy (kèm cà vẹt gốc) giá trị 30 triệu",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          )
        ],
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

// Define the state variables
  bool _isDiscount10Checked = false;
  bool _isInsuranceFreeChecked = false;
  bool _isCoupon50Checked = false;
  bool requiresDeposit = true; // Change this to true/false based on your policy
  double depositPercentage = 0.3; // 30% deposit

// Widget to build the payment information card
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
    double sum = totalPrice;
    // Apply discounts based on checkbox state
    if (_isDiscount10Checked) {
      sum -= (sum * 0.1); // Apply a 10% discount
    }
    if (_isInsuranceFreeChecked) {
      // Apply insurance discount or waive insurance fee
      // Update totalPrice accordingly
    }
    if (_isCoupon50Checked) {
      // Apply coupon discount
      // Update totalPrice accordingly
    }
    double depositAmount = 0.0;
    if (requiresDeposit) {
      depositAmount = sum - (sum * depositPercentage);
    }

    double remainingBalance = totalPrice - depositAmount;
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
              Text(
                "Chọn khuyến mãi (nếu có)",
                // Promotion selection (if available)
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              CheckboxListTile(
                title: Text("Giảm giá 10%"),
                value: _isDiscount10Checked,
                onChanged: (bool? value) {
                  setState(() {
                    _isDiscount10Checked = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text("Miễn phí bảo hiểm"),
                value: _isInsuranceFreeChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _isInsuranceFreeChecked = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text("Coupon giảm giá 50%"),
                value: _isCoupon50Checked,
                onChanged: (bool? value) {
                  setState(() {
                    _isCoupon50Checked = value!;
                  });
                },
              ),
              Divider(),
              _buildInfoTile("Tổng giá", "$sum đ"),
              if (requiresDeposit) ...[
                _buildInfoTile(
                    "Đặt cọc", "${depositAmount.toStringAsFixed(2)} đ"),
                _buildInfoTile("Số dư còn lại",
                    "${remainingBalance.toStringAsFixed(2)} đ"),
              ] else ...[
                _buildInfoTile(
                    "Thành tiền", "${totalPrice.toStringAsFixed(2)} đ"),
                _buildInfoTile("Thanh toán khi nhận xe",
                    "Vui lòng thanh toán ${totalPrice.toStringAsFixed(2)} đ khi nhận xe"),
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
 bool _isPolicyAgreed =true;
  Widget _buildButton() {
    return Container(
      margin: EdgeInsets.all(12),
      child: Column(  // Wrap button with a Column for better layout
        mainAxisSize: MainAxisSize.min,  // Prevent unnecessary space
        children: [
          Row(  // Add a Row for checkbox and label
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
              Text(
                "Tôi đồng ý với các điều khoản và chính sách",
                style: TextStyle(fontSize: 14,decoration: TextDecoration.underline),

              ),
            ],
          ),
          SizedBox(height: 10),  // Add spacing between checkbox and button
          MaterialButton(
            onPressed: () {
              if (_isPolicyAgreed) {
                _createBooking();  // Call booking function only if agreed
              } else {
                // Show message or handle user not agreeing
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Vui lòng đồng ý với chính sách trước khi gửi yêu cầu"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            height: 50,
            minWidth: double.infinity,
            color: Colors.teal,
            child: Text(
              "Gửi yêu cầu thuê xe",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
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
