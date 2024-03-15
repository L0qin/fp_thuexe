import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fp_thuexe/repository/repository.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';

class DetailCar extends StatefulWidget {
  const DetailCar({super.key});

  @override
  State<DetailCar> createState() => _DetailCarState();
}

class _DetailCarState extends State<DetailCar> {
  TextEditingController _soNgay = TextEditingController();
  int _sliderIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // _controller.dispose();
    // super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.all(12.0)),
                Card(
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
                                autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: true,
                                scrollDirection: Axis.horizontal,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _sliderIndex = index;
                                  });
                                },
                              ),
                              items: [
                                Image.asset(
                                  'assets/images/cars/land_rover_0.png',
                                  fit: BoxFit.cover,
                                ),
                                Image.asset(
                                  'assets/images/cars/land_rover_1.png',
                                  fit: BoxFit.cover,
                                ),
                                Image.asset(
                                  'assets/images/cars/land_rover_2.png',
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                            Positioned(
                              bottom: 16.0,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(3, (index) {
                                  return Container(
                                    width: 8.0,
                                    height: 8.0,
                                    margin:
                                    EdgeInsets.symmetric(horizontal: 4.0),
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
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sport",
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
                                  '5.0',
                                  style: TextStyle(
                                    color: Colors.yellow[800],
                                    fontSize: 24,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 1),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Land Rover",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Text(
                              '500VNĐ/Ngày',
                              style: TextStyle(
                                color: Colors.yellow[800],
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 1),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Mô tả",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 1),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      margin: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.speed_sharp,
                            size: 50,
                          ),
                          Text(
                            "250 km/h",
                            style: TextStyle(
                              color: Colors.yellow[800],
                              fontSize: 24,
                            ),
                          ),
                          Text(
                            "Power",
                            style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.build_circle_outlined,
                            size: 50,
                          ),
                          Text(
                            "2024 Model",
                            style: TextStyle(
                              color: Colors.yellow[800],
                              fontSize: 24,
                            ),
                          ),
                          Text(
                            "Year",
                            style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.local_gas_station,
                            size: 50,
                          ),
                          Text(
                            "7.0 L",
                            style: TextStyle(
                              color: Colors.yellow[800],
                              fontSize: 24,
                            ),
                          ),
                          Text(
                            "Fuel Consumption",
                            style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1),
                // Select Location
                Padding(
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
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.location_pin,
                                      color: const Color(0xff3b22a1),
                                      size: 24,
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Katowice Airport',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Wolności 90, 42-625 Pyrzowice',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 10), // Khoảng cách giữa phần "Select Location" và phần "Preview Map"
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    color: Colors.black,
                                    child: Center(
                                      child: Text(
                                        "Preview Map",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10), // Khoảng cách giữa hai phần mở rộng
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    color: Colors.red, // Màu sắc chỉ là ví dụ
                                    child: Center(
                                      child: Text(
                                        "Additional Content",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.add, size: 32, color: Colors.white), // Màu của biểu tượng
                  label: Text(
                    'Lựa chọn',
                    style: TextStyle(fontSize: 28, color: Colors.white), // Màu của chữ
                  ),
                  onPressed: () {
                    // Thực hiện hành động khi nút được nhấn
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Màu nền của nút
                    // Các thuộc tính khác như padding, shape, textStyle, ...
                  ),
                ),




              ],
            ),
          );
        },
      ),
    );
  }
}

// Widget _sliderWidgetCard(SizingInformation sizingInformation) {
//   return Container(
//     padding: const EdgeInsets.symmetric(horizontal: 5),
//     child: ClipRRect(
//       borderRadius: BorderRadius.circular(10),
//       child: CarouselSlider(
//         options: CarouselOptions(
//             height: 260.0,
//             aspectRatio: 0.10,
//             viewportFraction: 2.0,
//             autoPlay: true,
//             onPageChanged: (index, reason) {
//               setState(() {
//                 _sliderIndex = index;
//               });
//             }),
//         items: FakeRepository.sliderData.map((sliderData) {
//           return Builder(
//             builder: (_) {
//               return InkWell(
//                 onTap: () {
//                   // Navigator.push(
//                   //     context,
//                   //     MaterialPageRoute(
//                   //       builder: (_) => CarDetailPage(
//                   //         image: sliderData.sliderImage,
//                   //       ),
//                   //     ));
//                 },
//                 child: Card(
//                   child: Column(
//                     children: <Widget>[
//                       Stack(
//                         children: <Widget>[
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 30, vertical: 5),
//                             height: 190,
//                             width: sizingInformation.screenSize.width,
//                             child: ClipRRect(
//                               borderRadius:
//                                   const BorderRadius.all(Radius.circular(10)),
//                               child: Image.asset(
//                                 "assets/images/cars/kiamorning.jpg",
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             right: 18,
//                             child: Container(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 10),
//                               decoration: const BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.only(
//                                     bottomLeft: Radius.circular(10)),
//                               ),
//                               child: Row(
//                                 children: <Widget>[
//                                   const Icon(
//                                     Icons.star,
//                                     color: Colors.red,
//                                   ),
//                                   Text(
//                                     sliderData.rating,
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             right: 18,
//                             bottom: 0,
//                             left: 18,
//                             child: Container(
//                               margin:
//                                   const EdgeInsets.symmetric(horizontal: 135),
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 10),
//                               decoration: const BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.only(
//                                     topRight: Radius.circular(10),
//                                     topLeft: Radius.circular(10)),
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: FakeRepository.sliderData
//                                     .map((sliderData) {
//                                   return Container(
//                                     height: 7.0,
//                                     width: 7.0,
//                                     margin: const EdgeInsets.symmetric(
//                                         vertical: 4.0, horizontal: 2.0),
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: _sliderIndex ==
//                                               FakeRepository.sliderData
//                                                   .indexOf(sliderData)
//                                           ? Colors.red
//                                           : Colors.black,
//                                     ),
//                                   );
//                                 }).toList(),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 30),
//                         child: Column(
//                           children: <Widget>[
//                             const SizedBox(
//                               height: 15,
//                             ),
//                             Container(
//                               width: sizingInformation.localWidgetSize.width *
//                                   0.80,
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: <Widget>[
//                                   Text(
//                                     sliderData.title,
//                                     style: const TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   Row(
//                                     children: <Widget>[
//                                       Text(
//                                         sliderData.totalStar,
//                                         style: const TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 24),
//                                       ),
//                                       const SizedBox(width: 5),
//                                       const Text("star")
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         }).toList(),
//       ),
//     ),
//   );
// }
//}
