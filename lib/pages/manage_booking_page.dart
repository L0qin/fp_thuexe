import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/ManageBooking.dart';
import '../services/BookingService.dart';
import '../services/ImageService.dart';
import '../services/UserService.dart';

class ManageRentalsScreen extends StatefulWidget {
  @override
  _ManageRentalsScreenState createState() => _ManageRentalsScreenState();
}

class _ManageRentalsScreenState extends State<ManageRentalsScreen> {
  int? ownerId;
  late Future<List<ManageBooking>?>? manageBookingFuture;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final id = await getUserId();
      if (id != null && id != -1) {
        setState(() {
          ownerId = id;
        });
        manageBookingFuture = BookingService.getManagedBookings(ownerId ?? -1);

        await UserService.readAllBookingNotifications(ownerId ?? -1);
      } else {
        setState(() {
          ownerId = -1;
        });
        manageBookingFuture = Future.value(null);
      }
    } catch (e) {
      print('Initialization failed: $e');
    }
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId =
        prefs.getString('userId'); // Assuming userId is stored as String
    return userId != null ? int.tryParse(userId) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hành Trình Thuê Xe'),
        backgroundColor: Colors.teal.shade700,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context, 'refresh');
            } else {}
          },
        ),
      ),
      body: FutureBuilder<List<ManageBooking>?>(
        future: manageBookingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('No bookings found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final booking = snapshot.data![index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                  ImageService.getImageByName(
                                      booking.renterImage)),
                              radius: 30,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(booking.vehicleName,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  Text('Người thuê: ${booking.renterName}'),
                                  Text(
                                      'Từ: ${booking.startDate} đến: ${booking.endDate}'),
                                  Text('Địa chỉ nhận: ${booking.address}'),
                                  Text('Tổng tiển: ${booking.rentalCost}'),
                                  Text(
                                      'Ghi chú của người thuê: ${booking.notes.isEmpty ? "Không có" : booking.notes}'),
                                  _buildBookingStatusText(booking),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ActionCard(
                                booking: booking,
                                onActionTaken: refreshBookings),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void refreshBookings() {
    setState(() {
      // Reset the Future to re-fetch the bookings data
      // You might need to ensure ownerId is set before calling this
      if (ownerId != null) {
        manageBookingFuture = BookingService.getManagedBookings(ownerId ?? -1);
      }
    });
  }

  Widget _buildBookingStatusText(ManageBooking booking) {
    Color textColor;
    String statusText;

    switch (booking.bookingStatus) {
      case 0:
        statusText = "Chưa xác nhận";
        textColor = Colors.orange;
        break;
      case 1:
        statusText = "Đã xác nhận";
        textColor = Colors.green;
        break;
      case -1:
        statusText = "Đã huỷ";
        textColor = Colors.red;
        break;
      default: // Assuming this covers the "completed" status
        statusText = "Đã hoàn thành";
        textColor = Colors.blue;
    }

    return Text(
      'Trạng thái: $statusText',
      style: TextStyle(color: textColor),
    );
  }
}

class ActionCard extends StatefulWidget {
  final ManageBooking booking;
  final VoidCallback onActionTaken;

  ActionCard({required this.booking, required this.onActionTaken});

  @override
  _ActionCardState createState() => _ActionCardState();
}

class _ActionCardState extends State<ActionCard> {
  bool _isConfirmDisabled = false;
  bool _isCancelDisabled = false;
  bool _isCompleteDisabled = true; // Initially, the complete button is disabled

  @override
  void initState() {
    super.initState();
    // Initialize button states based on the booking status
    if (widget.booking.bookingStatus == 2 ||
        widget.booking.bookingStatus == -1) {
      // If the booking status is 'hoàn thành' (completed)
      _isConfirmDisabled = true;
      _isCancelDisabled = true;
      _isCompleteDisabled = true;
    }
    if (widget.booking.bookingStatus == 1) {
      // If the booking status is 'hoàn thành' (completed)
      _isConfirmDisabled = true;
      _isCancelDisabled = true;
      _isCompleteDisabled = false;
    }
  }

  void _handleConfirmOrCancel() async {
    try {
      // Simulate either confirm or cancel action here
      bool result = await BookingService.confirmBooking(
          widget.booking.bookingId); // or cancelBooking
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Đã xác nhận giao địch đặt xe, hãy liên hệ với người đặt và giao xe')));
        setState(() {
          // Disable both confirm and cancel buttons
          _isConfirmDisabled = true;
          _isCancelDisabled = true;
          // Enable the complete button
          _isCompleteDisabled = false;
          widget.onActionTaken();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    }
  }

  void _handleComplete() async {
    try {
      bool result =
          await BookingService.completeBooking(widget.booking.bookingId);
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Đã hoàn thành giao dịch đặt xe')));
        setState(() {
          // Disable the complete button after successful completion
          _isCompleteDisabled = true;
          widget.onActionTaken();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Có lỗi trong quá trình thựch iện: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _isConfirmDisabled
                      ? null
                      : () => _handleConfirmOrCancel(),
                  child: Text('Đồng ý', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                ),
                ElevatedButton(
                  onPressed:
                      _isCancelDisabled ? null : () => _handleConfirmOrCancel(),
                  child: Text('Từ chối', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
                ElevatedButton(
                  onPressed:
                      _isCompleteDisabled ? null : () => _handleComplete(),
                  child:
                      Text('Hoàn thành', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
