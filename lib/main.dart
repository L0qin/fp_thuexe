import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fp_thuexe/Information.dart';
import 'package:fp_thuexe/PostCar.dart';
import 'package:fp_thuexe/detailCar.dart';
import 'package:fp_thuexe/repository/repository.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'core.dart';
import 'search.dart';

void main() {
  // runApp(Search());
  runApp(MaterialApp(
    title: 'My app', // used by the OS task switcher
    home: Information(),
    //test
  ));
}

class HomePage extends StatefulWidget {
  static const title = 'Thuê xe';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _navBarPageSelector = 0;
  int _rowButtonController = 0;
  int _sliderIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Thuê xe",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: ResponsiveBuilder(
          builder: (context, sizingInformation) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.only(top: 15, right: 15, left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // HeaderWidget
                    _headerWidget(),
                    const SizedBox(
                      height: 10,
                    ),
                    _cardTimeWidget(sizingInformation),
                    const SizedBox(
                      height: 10,
                    ),
                    _rowButtons(),
                    const SizedBox(
                      height: 15,
                    ),
                    _sliderWidgetCard(sizingInformation),
                    const SizedBox(
                      height: 15,
                    ),
                    _popularCarsHeadingWidget(),
                    const SizedBox(
                      height: 15,
                    ),
                    // _listCarWidgetHorizontal(sizingInformation),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: const BottomBar(),
      ),
    );
  }

  Widget _headerWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(
          height: 40,
          width: 40,
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(40)),
              child: Image.asset(
                'assets/images/icons/user.png',
              )),
        ),
        const Column(
          children: <Widget>[
            Text(
              "Location",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            SizedBox(
              height: 2,
            ),
            Row(
              children: <Widget>[
                Text("Gulshan-e-Iqbalm, Karachi, Pakistan"),
                Icon(Icons.arrow_drop_down),
              ],
            )
          ],
        ),
        const Icon(Icons.image)
      ],
    );
  }

  Widget _rowButtons() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _rowButtonSingleItem(
              image: "assets/images/icons/car.png",
              title: "Ô tô",
              selectedItemTextColor:
              _rowButtonController == 0 ? Colors.red : Colors.black,
              selectedBgColor:
              _rowButtonController == 0 ? Colors.red : Colors.white,
              selectedItemIconColor:
              _rowButtonController == 0 ? Colors.white : Colors.red,
              onPressed: () {
                setState(() {
                  _rowButtonController = 0;
                });
              }),
          _rowButtonSingleItem(
              image: "assets/images/icons/electric_car.png",
              title: "Ô tô đện",
              selectedItemTextColor:
              _rowButtonController == 1 ? Colors.red : Colors.black,
              selectedBgColor:
              _rowButtonController == 1 ? Colors.red : Colors.white,
              selectedItemIconColor:
              _rowButtonController == 1 ? Colors.white : Colors.red,
              onPressed: () {
                setState(() {
                  _rowButtonController = 1;
                });
              }),
          _rowButtonSingleItem(
              image: "assets/images/icons/scooter.png",
              title: "Xe máy",
              selectedItemTextColor:
              _rowButtonController == 3 ? Colors.red : Colors.black,
              selectedBgColor:
              _rowButtonController == 3 ? Colors.red : Colors.white,
              selectedItemIconColor:
              _rowButtonController == 3 ? Colors.white : Colors.red,
              onPressed: () {
                setState(() {
                  _rowButtonController = 3;
                });
              }),
          _rowButtonSingleItem(
              image: "assets/images/icons/electric_scooter.png",
              title: "Xe máy điện",
              selectedItemTextColor:
              _rowButtonController == 4 ? Colors.red : Colors.black,
              selectedBgColor:
              _rowButtonController == 4 ? Colors.red : Colors.white,
              selectedItemIconColor:
              _rowButtonController == 4 ? Colors.white : Colors.red,
              onPressed: () {
                setState(() {
                  _rowButtonController = 4;
                });
              }),
        ],
      ),
    );
  }

  Widget _rowButtonSingleItem({
    required String image,
    required String title,
    Color? selectedBgColor,
    Color? selectedItemIconColor,
    Color? selectedItemTextColor,
    VoidCallback? onPressed,
  }) {
    return Container(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: onPressed,
            child: Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: selectedBgColor,
                  borderRadius: const BorderRadius.all(Radius.circular(50))),
              child: Image.asset(
                image,
                color: selectedItemIconColor,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: TextStyle(
                color: selectedItemTextColor, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget _sliderWidgetCard(SizingInformation sizingInformation) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CarouselSlider(
          options: CarouselOptions(
              height: 260.0,
              aspectRatio: 0.10,
              viewportFraction: 2.0,
              autoPlay: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _sliderIndex = index;
                });
              }
          ),
          items: FakeRepository.sliderData.map((sliderData) {
            return Builder(
              builder: (_) {
                return InkWell(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (_) => CarDetailPage(
                    //         image: sliderData.sliderImage,
                    //       ),
                    //     ));
                  },
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 5),
                              height: 190,
                              width: sizingInformation.screenSize.width,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                child: Image.asset(
                                  "assets/images/cars/kiamorning.jpg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 18,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10)
                                  ),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    const Icon(
                                      Icons.star,
                                      color: Colors.red,
                                    ),
                                    Text(
                                      sliderData.rating,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              right: 18,
                              bottom: 0,
                              left: 18,
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 135),
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10)
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: FakeRepository.sliderData.map((sliderData) {
                                    return Container(
                                      height: 7.0,
                                      width: 7.0,
                                      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _sliderIndex == FakeRepository.sliderData.indexOf(sliderData)
                                            ? Colors.red
                                            : Colors.black,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            children: <Widget>[
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                width: sizingInformation.localWidgetSize.width * 0.80,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      sliderData.title,
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          sliderData.totalStar,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                                        ),
                                        const SizedBox(width: 5),
                                        const Text("star")
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }


  // Widget _listCarWidgetHorizontal(SizingInformation sizingInformation) {
  //   return Container(
  //     height: 190,
  //     padding: EdgeInsets.symmetric(horizontal: 5),
  //     child: Card(
  //       child: PageView.builder(
  //         scrollDirection: Axis.horizontal,
  //         itemCount: FakeRepository.listViewData.length,
  //         itemBuilder: (BuildContext context, int index) {
  //           return _listViewItem(index, sizingInformation);
  //         },
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _listViewItem(int index, SizingInformation sizingInformation) {
  //   return Stack(
  //     children: <Widget>[
  //       Column(
  //         children: <Widget>[
  //           Container(
  //             padding: EdgeInsets.symmetric(horizontal: 10),
  //             height: 130,
  //             width: sizingInformation.localWidgetSize.width,
  //             child: ClipRRect(
  //                 borderRadius: BorderRadius.all(Radius.circular(10)),
  //                 child: Image.asset(
  //                   FakeRepository.listViewData[index].sliderImage,
  //                   fit: BoxFit.cover,
  //                 )),
  //           ),
  //         ],
  //       ),
  //       Positioned(
  //         right: 0,
  //         child: Container(
  //           padding: EdgeInsets.symmetric(horizontal: 10),
  //           decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius:
  //                   BorderRadius.only(bottomLeft: Radius.circular(10))),
  //           child: Row(
  //             children: <Widget>[
  //               Icon(
  //                 Icons.star,
  //                 color: Colors.red,
  //               ),
  //               Text(
  //                 FakeRepository.listViewData[index].rating,
  //                 style: TextStyle(fontWeight: FontWeight.bold),
  //               )
  //             ],
  //           ),
  //         ),
  //       ),
  //       Positioned(
  //         bottom: 0,
  //         left: 0,
  //         right: 0,
  //         child: Align(
  //           alignment: Alignment.bottomCenter,
  //           child: Container(
  //             padding: EdgeInsets.symmetric(horizontal: 20),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: <Widget>[
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: <Widget>[
  //                     Text(
  //                       FakeRepository.listViewData[index].title,
  //                       style: TextStyle(
  //                           fontWeight: FontWeight.bold, fontSize: 18),
  //                     ),
  //                     Row(
  //                       children: <Widget>[
  //                         Text(
  //                           FakeRepository.listViewData[index].totalStar,
  //                           style: TextStyle(
  //                               fontWeight: FontWeight.bold, fontSize: 24),
  //                         ),
  //                         Text("Star"),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //                 Text(
  //                     "${FakeRepository.listViewData[index].totalTrips} Trips"),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }

  Widget _popularCarsHeadingWidget() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          "Popular Cars",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 5,
        ),
        Text("Popular Car: United Arab")
      ],
    );
  }

  Widget _cardTimeWidget(SizingInformation sizingInformation) {
    return Container(
      height: 150,
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 150,
                width: sizingInformation.localWidgetSize.width * 0.45,
                child: const Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "10",
                        style: TextStyle(
                            fontSize: 38, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Sunday, May 25",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Time: 10:00",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 150,
                width: sizingInformation.localWidgetSize.width * 0.45,
                child: const Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "11",
                        style: TextStyle(
                            fontSize: 38, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Sunday, Nov 26",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Time: 10:00",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: const Icon(
                Icons.arrow_forward,
                size: 28,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}