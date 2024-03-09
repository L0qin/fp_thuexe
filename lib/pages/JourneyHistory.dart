import 'package:flutter/material.dart';

class JourneyHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hành Trình Thuê Xe'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            JourneyHistoryItem(
              carType: "Kia",
              renterName: "Phạm Trường",
              location: "Cao Lỗ",
              rentalDuration: "3 ngày",
              cost: "250VNĐ/Ngày",
            ),
            SizedBox(height: 16.0),
            JourneyHistoryItem(
              carType: "Toyota",
              renterName: "Nguyễn Thị An",
              location: "Đống Đa",
              rentalDuration: "2 ngày",
              cost: "200VNĐ/Ngày",
            ),
            // Add more items to the ListView as needed
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

  const JourneyHistoryItem({
    required this.carType,
    required this.renterName,
    required this.location,
    required this.rentalDuration,
    required this.cost,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/icons/car.png'),
            ),
            SizedBox(width: 30),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    carType,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.normal,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Người thuê: $renterName",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Địa điểm: $location",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Thời gian thuê: $rentalDuration",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Chi phí: $cost",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


