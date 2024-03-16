import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fp_thuexe/services/ImageService.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../models/Vehicle.dart';
import '../services/VehicleService.dart';

class DetailCar extends StatefulWidget {
  DetailCar(this.carId);

  int carId;

  @override
  State<DetailCar> createState() => _DetailCarState(carId);
}

class _DetailCarState extends State<DetailCar> {
  int carId;
  TextEditingController _soNgay = TextEditingController();
  int _sliderIndex = 0;
  Vehicle? _vehicle; // Initialize _vehicle to null
  late List<String> _imageURLs = [];
  late Timer _timer;

  _DetailCarState(this.carId);

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _checkVehicleStatus();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _checkVehicleStatus() {
    if (_vehicle == null || _imageURLs.isEmpty) {
      _getVehicleInfo();
      _getImageURLs();
    } else {
      _timer.cancel();
    }
  }

  Future<void> _getVehicleInfo() async {
    try {
      Vehicle? vehicle = await VehicleService.getVehicleById(carId);
      setState(() {
        _vehicle = vehicle!;
      });
    } catch (e) {
      print('Failed to retrieve vehicle: $e');
    }
  }

  Future<void> _getImageURLs() async {
    try {
      List<String> imageURLs = await ImageService.getAllVehicleImageURLsById(carId);
      setState(() {
        _imageURLs = imageURLs;
      });
    } catch (e) {
      print('Failed to retrieve image URLs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _vehicle != null ? _vehicle!.carName : "...",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildCarouselSlider(),
                _buildTextWithIconRow(_vehicle != null ? _vehicle!.model : "...", _vehicle != null ? "${_vehicle!.rentalPrice}VNĐ/Ngày" : "500VNĐ/Ngày"),
                _buildDescription(_vehicle != null ? _vehicle!.description : "..."),
                _buildInfoCardsRow("","",1),
                _buildLocationSelection(_vehicle != null ? _vehicle!.address : "Katowice Airport"),
                _buildElevatedButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCarouselSlider() {
    if (_imageURLs.isNotEmpty) {
      return Card(
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          children: [
            Container(
              height: 300, // Set height of the CarouselSlider
              child: Stack(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 300,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _sliderIndex = index;
                        });
                      },
                    ),
                    items: _imageURLs.map((imageUrl) {
                      return Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      );
                    }).toList(),
                  ),
                  Positioned(
                    bottom: 16.0,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_imageURLs.length, (index) {
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _sliderIndex == index
                                ? Colors.blue
                                : Colors
                                    .grey, // Color of selected and unselected dots
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10), // Spacing between elements
          ],
        ),
      );
    } else {
      return SizedBox
          .shrink(); // Return an empty SizedBox if _imageURLs is empty
    }
  }

  Widget _buildTextWithIconRow(String text, String rating) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.yellow[800],
                size: 24,
              ),
              Text(
                rating,
                style: TextStyle(
                  color: Colors.yellow[800],
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(String description) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Mô tả",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 1),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 1),
        ],
      ),
    );
  }

  Widget _buildInfoCardsRow(String model, String rentalPrice, int seating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildInfoCard(Icons.speed_sharp, "250 km/h", "Power"),
        _buildInfoCard(Icons.build_circle_outlined, model, "Year"),
        _buildInfoCard(
            Icons.local_gas_station, rentalPrice, "Fuel Consumption"),
      ],
    );
  }

  Widget _buildInfoCard(IconData icon, String value, String label) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 50,
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.yellow[800],
              fontSize: 24,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.yellow,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSelection(String address) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Location",
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          // Thêm khoảng cách giữa tiêu đề và phần chọn vị trí
          Center(
            child: Container(
                // Widget giả lập
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildElevatedButton() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: ElevatedButton.icon(
        icon: Icon(Icons.add, size: 32, color: Colors.white),
        label: Text(
          'Lựa chọn',
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
        onPressed: () {
          // Thực hiện hành động khi nút được nhấn
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          // Các thuộc tính khác như padding, shape, textStyle, ...
        ),
      ),
    );
  }
}

// Code cũ-----------------------------------------------------------------------------------------
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(title: Text("Land Rover",style:TextStyle(color: Colors.teal) ,),),
//     body: ResponsiveBuilder(
//       builder: (context, sizingInformation) {
//         return SingleChildScrollView(
//           child: Column(
//             children: [
//               Padding(padding: EdgeInsets.all(12.0)),
//               Card(
//                 margin: EdgeInsets.all(10),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12.0),
//                 ),
//                 child: Column(
//                   children: [
//                     Container(
//                       height: 300, // Set height of the CarouselSlider
//                       child: Stack(
//                         children: [
//                           CarouselSlider(
//                             options: CarouselOptions(
//                               height: 300,
//                               enableInfiniteScroll: true,
//                               autoPlay: true,
//                               autoPlayInterval: Duration(seconds: 3),
//                               autoPlayAnimationDuration:
//                               Duration(milliseconds: 800),
//                               autoPlayCurve: Curves.fastOutSlowIn,
//                               enlargeCenterPage: true,
//                               scrollDirection: Axis.horizontal,
//                               onPageChanged: (index, reason) {
//                                 setState(() {
//                                   _sliderIndex = index;
//                                 });
//                               },
//                             ),
//                             items: [
//                               Image.asset(
//                                 'assets/images/cars/land_rover_0.png',
//                                 fit: BoxFit.cover,
//                               ),
//                               Image.asset(
//                                 'assets/images/cars/land_rover_1.png',
//                                 fit: BoxFit.cover,
//                               ),
//                               Image.asset(
//                                 'assets/images/cars/land_rover_2.png',
//                                 fit: BoxFit.cover,
//                               ),
//                             ],
//                           ),
//                           Positioned(
//                             bottom: 16.0,
//                             left: 0,
//                             right: 0,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: List.generate(3, (index) {
//                                 return Container(
//                                   width: 8.0,
//                                   height: 8.0,
//                                   margin:
//                                   EdgeInsets.symmetric(horizontal: 4.0),
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: _sliderIndex == index
//                                         ? Colors.blue
//                                         : Colors
//                                         .grey, // Color of selected and unselected dots
//                                   ),
//                                 );
//                               }),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 10), // Spacing between elements
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Sport",
//                             style: TextStyle(
//                               color: Colors.blue,
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Spacer(),
//                           Row(
//                             children: [
//                               Icon(
//                                 Icons.star,
//                                 color: Colors.yellow[800],
//                                 size: 24,
//                               ),
//                               Text(
//                                 '5.0',
//                                 style: TextStyle(
//                                   color: Colors.yellow[800],
//                                   fontSize: 24,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 1),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Land Rover",
//                             style: TextStyle(
//                               color: Colors.blue,
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Spacer(),
//                           Text(
//                             '500VNĐ/Ngày',
//                             style: TextStyle(
//                               color: Colors.yellow[800],
//                               fontSize: 24,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 1),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Mô tả",
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 1),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Flexible(
//                             child: Text(
//                               "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi.",
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Card(
//                     margin: EdgeInsets.all(10),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                     ),
//                     child: Column(
//                       children: [
//                         Icon(
//                           Icons.speed_sharp,
//                           size: 50,
//                         ),
//                         Text(
//                           "250 km/h",
//                           style: TextStyle(
//                             color: Colors.yellow[800],
//                             fontSize: 24,
//                           ),
//                         ),
//                         Text(
//                           "Power",
//                           style: TextStyle(
//                             color: Colors.yellow,
//                             fontSize: 20,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Card(
//                     margin: EdgeInsets.all(10),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                     ),
//                     child: Column(
//                       children: [
//                         Icon(
//                           Icons.build_circle_outlined,
//                           size: 50,
//                         ),
//                         Text(
//                           "2024 Model",
//                           style: TextStyle(
//                             color: Colors.yellow[800],
//                             fontSize: 24,
//                           ),
//                         ),
//                         Text(
//                           "Year",
//                           style: TextStyle(
//                             color: Colors.yellow,
//                             fontSize: 20,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Card(
//                     margin: EdgeInsets.all(10),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                     ),
//                     child: Column(
//                       children: [
//                         Icon(
//                           Icons.local_gas_station,
//                           size: 50,
//                         ),
//                         Text(
//                           "7.0 L",
//                           style: TextStyle(
//                             color: Colors.yellow[800],
//                             fontSize: 24,
//                           ),
//                         ),
//                         Text(
//                           "Fuel Consumption",
//                           style: TextStyle(
//                             color: Colors.yellow,
//                             fontSize: 20,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 1),
//               // Select Location
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 20),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Select Location",
//                       style: TextStyle(
//                         fontSize: 24,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     // Thêm khoảng cách giữa tiêu đề và phần chọn vị trí
//                     Center(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.blue,
//                           borderRadius: const BorderRadius.all(
//                             Radius.circular(10),
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.location_pin,
//                                     color: const Color(0xff3b22a1),
//                                     size: 24,
//                                   ),
//                                   SizedBox(height: 2),
//                                   Text(
//                                     'Katowice Airport',
//                                     textAlign: TextAlign.center,
//                                     style: GoogleFonts.poppins(
//                                       color: Colors.white,
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Text(
//                                     'Wolności 90, 42-625 Pyrzowice',
//                                     textAlign: TextAlign.center,
//                                     style: GoogleFonts.poppins(
//                                       color: Colors.white,
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(width: 10), // Khoảng cách giữa phần "Select Location" và phần "Preview Map"
//                               Expanded(
//                                 flex: 1,
//                                 child: Container(
//                                   color: Colors.black,
//                                   child: Center(
//                                     child: Text(
//                                       "Preview Map",
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 10), // Khoảng cách giữa hai phần mở rộng
//                               Expanded(
//                                 flex: 1,
//                                 child: Container(
//                                   color: Colors.red, // Màu sắc chỉ là ví dụ
//                                   child: Center(
//                                     child: Text(
//                                       "Additional Content",
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               ElevatedButton.icon(
//                 icon: Icon(Icons.add, size: 32, color: Colors.white), // Màu của biểu tượng
//                 label: Text(
//                   'Lựa chọn',
//                   style: TextStyle(fontSize: 28, color: Colors.white), // Màu của chữ
//                 ),
//                 onPressed: () {
//                   // Thực hiện hành động khi nút được nhấn
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue, // Màu nền của nút
//                   // Các thuộc tính khác như padding, shape, textStyle, ...
//                 ),
//               ),
//
//
//
//
//             ],
//           ),
//         );
//       },
//     ),
//   );
// }
