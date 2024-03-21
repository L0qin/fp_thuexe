import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

// Ensure you have these imports
import '../models/VehicleBooking.dart';
import '../services/AuthService.dart';
import '../services/BookingService.dart';

class JourneyHistoryPage extends StatefulWidget {
  @override
  _JourneyHistoryPageState createState() => _JourneyHistoryPageState();
}

class _JourneyHistoryPageState extends State<JourneyHistoryPage> {
  Future<List<Booking?>?>? futureBookings;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  void _fetchBookings() async {
    try {
      final userId = await AuthService.getUserId(); // Wait for the userId
      final bookings = await BookingService.getBookingsByUserId(userId!);
      setState(() {
        futureBookings = Future.value(
            bookings); // Set the futureBookings with the resolved future
      });
    } catch (error) {
      print("Error fetching bookings: $error");
      setState(() {
        futureBookings = Future.value(
            []); // In case of error, set futureBookings to an empty list
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hành Trình Thuê Xe'),
        backgroundColor: Colors.teal.shade700,
      ),
      body: FutureBuilder<List<Booking?>?>(
        future: futureBookings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            // Show dummy data if real data fails to load
            return _buildDummyContent();
          } else {
            // Map through the bookings and create a list of widgets to display
            List<Widget> bookingWidgets = snapshot.data!
                .map((booking) => JourneyHistoryItem(
                      carType: "Giao dịch Id: #${booking!.bookingId}",
                      renterName: booking!.customerId.toString(),
                      location: booking.receivingAddress,
                      rentalDuration: "${booking.rentalDays} ngày",
                      cost: "${booking.totalRentalCost} VNĐ",
                      tripStart: booking.startDate.toString(),
                      tripEnd: booking.endDate.toString(),
                      paymentMethod: "Tiền mặt",
                      contactSupport: "support@example.com",
                    ))
                .toList();

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: bookingWidgets,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildDummyContent() {
    return Container();
  }
}

class JourneyHistoryItem extends StatelessWidget {
  final String carType;
  final String renterName;
  final String location;
  final String rentalDuration;
  final String cost;
  final String tripStart;
  final String tripEnd;
  final String paymentMethod;
  final String contactSupport;

  const JourneyHistoryItem({
    required this.carType,
    required this.renterName,
    required this.location,
    required this.rentalDuration,
    required this.cost,
    required this.tripStart,
    required this.tripEnd,
    required this.paymentMethod,
    required this.contactSupport,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: CircleAvatar(
                radius: 60,
                backgroundImage:
                    AssetImage('assets/images/cars/land_rover_0.png'),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  carType,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Người Thuê: $renterName",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "Địa Điểm: $location",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "Thời Gian Thuê: $rentalDuration",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "Chi Phí: $cost",
                  style: TextStyle(fontSize: 16),
                ),
                Divider(),
                Text(
                  "Thời Gian Bắt Đầu: $tripStart",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "Thời Gian Kết Thúc: $tripEnd",
                  style: TextStyle(fontSize: 16),
                ),
                Divider(),
                Text(
                  "Phương Thức Thanh Toán: $paymentMethod",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Điều hướng đến trang hỗ trợ khi nhấn vào nút
                      },
                      child: Text(
                        "Liên Hệ Hỗ Trợ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
