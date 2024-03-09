
import 'package:flutter/material.dart';

class AnnouncementPage extends StatelessWidget {
  const AnnouncementPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông Báo Thuê Xe'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildAnnouncementCard(
              title: "Thuê Xe giá rẻ",
              subtitle: "Dành cho các Khách Hàng muốn tiết kiêm hàng trăm triệu đồng",
              imagePath: 'assets/images/icons/car.png',
            ),
            SizedBox(height: 16.0),
            buildAnnouncementCard(
              title: "Ưu đãi đặc biệt",
              subtitle: "Nhận ngay voucher giảm giá cho đơn thuê xe đầu tiên",
              imagePath: 'assets/images/icons/car.png',
            ),
            SizedBox(height: 16.0),
            buildAnnouncementCard(
              title: "Dịch vụ chất lượng",
              subtitle: "Đội ngũ lái xe chuyên nghiệp và xe luôn được bảo dưỡng định kỳ",
              imagePath: 'assets/images/icons/car.png',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAnnouncementCard({required String title, required String subtitle, required String imagePath}) {
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
              backgroundImage: AssetImage(imagePath),
            ),
            SizedBox(width: 30),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.normal,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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
