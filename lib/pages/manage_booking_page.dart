import 'package:flutter/material.dart';

import '../services/BookingService.dart';

class ManageRentalsScreen extends StatefulWidget {
  @override
  _ManageRentalsScreenState createState() => _ManageRentalsScreenState();
}

class _ManageRentalsScreenState extends State<ManageRentalsScreen> {
  Future<List<dynamic>?>? futureManagedBookings;

  @override
  void initState() {
    super.initState();
    int ownerId = 1;
    futureManagedBookings = BookingService.getManagedBookings(ownerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý cho thuê'),
        backgroundColor: Colors.teal.shade700,
      ),
      body: FutureBuilder<List<dynamic>?>(
        future: futureManagedBookings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('Lỗi khi tải dữ liệu'));
          } else {
            // Assuming snapshot.data contains the list of bookings
            final bookings = snapshot.data!;
            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return ListTile(
                  title: Text(booking['ten_xe'] ?? 'Unknown Vehicle'),
                  subtitle: Text('Người thuê: ${booking['renter_name']}'),
                  trailing: Text('Giá: ${booking['tong_tien_thue']} VNĐ'),
                  // Additional details can be displayed as needed
                  onTap: () {
                    // Handle tap if necessary
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
