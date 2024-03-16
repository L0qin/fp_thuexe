import 'package:flutter/material.dart';

class JourneyHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Hành Trình Thuê Xe'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            JourneyHistoryItem(
              carType: "Kia",
              renterName: "Phạm Trường",
              location: "Cao Lỗ",
              rentalDuration: "3 ngày",
              cost: "750,000 VNĐ",
              tripStart: "8:00 AM, 15/03/2024",
              tripEnd: "11:00 AM, 18/03/2024",
              paymentMethod: "Thanh toán tiền mặt",
              contactSupport: "support@example.com",
            ),
            SizedBox(height: 16.0),
            JourneyHistoryItem(
              carType: "Toyota",
              renterName: "Nguyễn Thị An",
              location: "Đống Đa",
              rentalDuration: "2 ngày",
              cost: "500,000 VNĐ",
              tripStart: "10:00 AM, 17/03/2024",
              tripEnd: "12:00 PM, 19/03/2024",
              paymentMethod: "Thanh toán thẻ tín dụng",
              contactSupport: "support@example.com",
            ),
            // Add more items to the Column as needed
          ],
        ),
      ),
    );
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
                backgroundImage: AssetImage('assets/images/cars/land_rover_0.png'),
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