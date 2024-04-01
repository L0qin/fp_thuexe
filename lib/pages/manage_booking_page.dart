import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/ManageBooking.dart';
import '../services/BookingService.dart';
import '../services/ImageService.dart';

class ManageRentalsScreen extends StatefulWidget {
  @override
  _ManageRentalsScreenState createState() => _ManageRentalsScreenState();
}

class _ManageRentalsScreenState extends State<ManageRentalsScreen> {
  int? ownerId;

  @override
  void initState() {
    super.initState();
    getUserId().then((id) {
      setState(() {
        ownerId = id;
      });
    });
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
        title: Text('Quản lý cho thuê'),
        backgroundColor: Colors.teal.shade700,
      ),
      body: FutureBuilder<List<ManageBooking>?>(
        future: BookingService.getManagedBookings(ownerId ?? -1),
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
                            _buildActionCard(booking),
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

  Widget _buildActionCard(ManageBooking booking) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Other widget elements like booking details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      final result = await BookingService.confirmBooking(booking.bookingId);
                      if (result) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Đặt xe được xác nhận')));
                        // Optionally refresh or update the UI here if needed
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Lỗi khi xác nhận Đặt xe: $e')));
                    }
                  },
                  child: Text('Đồng ý', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      final result = await BookingService.cancelBooking(booking.bookingId);
                      if (result) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Đặt xe đã bị hủy')));
                        // Optionally refresh or update the UI here if needed
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Lỗi khi hủy Đặt xe: $e')));
                    }
                  },
                  child: Text('Từ chối', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      final result = await BookingService.completeBooking(booking.bookingId);
                      if (result) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Đặt xe đã hoàn thành')));
                        // Optionally refresh or update the UI here if needed
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Lỗi khi hoàn thành Đặt xe: $e')));
                    }
                  },
                  child: Text('Hoàn thành', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
