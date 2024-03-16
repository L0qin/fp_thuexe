
import 'package:flutter/material.dart';

class AnnouncementPage extends StatelessWidget {
  const AnnouncementPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... other widgets ...
      body: ListView(
        children: [
          const SizedBox(height: 150,),
          _buildPromotion(),  // Add the promotion section
          //_buildHeader(),
          _buildPromotion(), // Use the updated _buildCarList function
          const SizedBox(height: 10,),
         // _buildCarList(),
          const SizedBox(height: 10,),
          _buildNewCar(),
          _buildCarVideo(),
        ],
      ),
    );
  }
  Widget _buildPromotion() {
    return Container(
      height: 160,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade800, Colors.blue.shade400],
        ),
      ),
      child: Stack(

        children: [
          Positioned(
            bottom: 10,
            left: 10,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white.withOpacity(0.8),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    "Thuê Xe giá rẻ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),

                  Text(
                    "Dành cho các Khách Hàng muốn tiết kiệm hàng trăm triệu đồng nhanh tay",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue[800],
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Hành động khi click nút
                    },
                    child: Text("Thuê Ngay"),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 0,
            child: Image.asset(
              'assets/images/cars/land_rover_0.png',
              width: 100,
              height: 70,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildCarList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 10, // Thay đổi số lượng xe
      itemBuilder: (context, index) {
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
                  backgroundImage: AssetImage('assets/images/cars/land_rover_0.png'),
                ),
                SizedBox(width: 30),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tên Xe",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.normal,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Giá Thuê",
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
      },
    );
  }
  Widget _buildCarVideo() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 3, // Number of items in the ListView.builder
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: Image.asset(
              'assets/images/cars/land_rover_0.png',
              width: 80, // Adjust the width of the image as needed
              height: 80, // Adjust the height of the image as needed
            ),
            title: Text(
              'Mazda 6',
              style: TextStyle(fontSize: 18),
            ),
            subtitle: Text(
              'Sedan hạng trung',
              style: TextStyle(fontSize: 14),
            ),
            onTap: () {
              // Action when the list tile is tapped
            },
          ),
        );
      },
    );
  }



}

Widget _buildNewCar() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20), // Adjust the horizontal padding as needed
    child: Center(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[200], // Background color for the main container
          borderRadius: BorderRadius.circular(10), // Border radius for the main container
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '2021 Mazda 6 sedan adds standard Apple CarPlay',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'By Blake Sep 18, 2020',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () {},
                  //   child: Text('Xem thêm'),
                  // ),
                ],
              ),
            ),
            SizedBox(width: 10), // Adjust the spacing between the text content and image
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black), // Border color for the image frame
                borderRadius: BorderRadius.circular(10),
                // Border radius for the image frame
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10), // Clip the image with border radius
                child: Image.asset(
                  'assets/images/cars/land_rover_0.png',
                  width: 120, // Adjust the width of the image as needed
                  height: 120, // Adjust the height of the image as needed
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}







  ////

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

