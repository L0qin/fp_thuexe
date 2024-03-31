import 'package:flutter/material.dart';

import '../models/VehicleBooking.dart';
import '../services/AuthService.dart';
import '../services/BookingService.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chuyến đi và lịch sử'),
        backgroundColor: Colors.teal.shade700,
      ),
      body: FutureBuilder<int?>(
        future: AuthService.getUserId(), // Adjusted for null safety
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data == null) {
            // User ID is null or not found
            return Center(child: Text('Người dùng không tồn tại.'));
          } else {
            // Proceed to fetch bookings only if the user ID is valid
            final userId = snapshot.data!;
            return FutureBuilder<List<Booking?>?>(
              future: BookingService.getAllUserBookings(userId),
              builder: (context, bookingSnapshot) {
                if (bookingSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (!bookingSnapshot.hasData ||
                    bookingSnapshot.data == null ||
                    bookingSnapshot.data!.isEmpty) {
                  return Center(child: Text('Không có giao dịch đặt xe.'));
                } else {
                  return ListView(
                    children: bookingSnapshot.data!
                        .map((booking) => _buildBookingCard(context, booking!))
                        .toList(),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
//======================================================================
  Widget _buildBookingCard(BuildContext context, Booking booking) {
    return Card(
      margin: EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: InkWell(
        onTap: () {}, // Placeholder for onTap action
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildBookingHeader(booking),
              // SizedBox(height: 10.0),
              // Text('Số ngày thuê: ${booking.rentalDays} ngày',
              //     style: TextStyle(fontSize: 16.0)),
              // SizedBox(height: 5.0),
              // Text('Tổng tiền: ${booking.totalRentalCost}vnđ',
              //     style: TextStyle(fontSize: 16.0)),
              // SizedBox(height: 10.0),
              // _buildStatusText(booking.status),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingHeader(Booking booking) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Giao dịch id: #${booking.id}',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade800)),
        Text('${booking.startDate.toIso8601String().split('T')[0]}',
            style: TextStyle(fontSize: 16.0, color: Colors.teal.shade600)),
      ],
    );
  }

  Widget _buildStatusText(int status) {
    return Row(
      children: [
        Icon(
          status == 2 ? Icons.check_circle : Icons.loop,
          color: status == 2 ? Colors.green : Colors.orange,
          size: 24,
        ),
        SizedBox(width: 5),
        Text(
          status == 2 ? "Đã hoàn thành" : "Đang hoạt động",
          style: TextStyle(
              color: status == 2 ? Colors.green : Colors.orange,
              fontSize: 16.0),
        ),
      ],
    );
  }
}
