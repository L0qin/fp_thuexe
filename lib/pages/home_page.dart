import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fp_thuexe/pages/login_page.dart';
import 'package:fp_thuexe/pages/search_page.dart';
import 'package:fp_thuexe/repository/repository.dart';
import 'package:fp_thuexe/services/AuthService.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomePage extends StatefulWidget {
  static const title = 'Thuê xe';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _rowButtonController = 0;
  int _sliderIndex = 0;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    // Check if token exists initially
    AuthService.getToken().then((token) {
      setState(() {
        _isLoggedIn = token != null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
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
                _searchWidget(),
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
                // _popularCarsHeadingWidget(),
                _sliderWidgetCard(sizingInformation), // Test UI, remove later
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
    );
  }

  Widget _headerWidget() {
    String buttonText = _isLoggedIn ? "Đăng xuất" : "Đăng nhập";
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 45,
            width: 45,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              child: Image.asset('assets/images/icons/user.png'),
            ),
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
                  Text("W4, D8, HCMC"),
                  Icon(Icons.arrow_drop_down),
                ],
              )
            ],
          ),
          MaterialButton(
            onPressed: () async {
              if (_isLoggedIn) {
                await AuthService.logout();
                setState(() {
                  _isLoggedIn = false;
                });
              } else {
                // Navigate to the login page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
                setState(() {
                  _isLoggedIn = AuthService.getToken() != null;
                });
              }
            },
            minWidth: 45,
            height: 50,
            splashColor: Colors.white12,
            color: Colors.teal,
            child: Text(
              buttonText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchPage()),
          );
        },
        child: TextField(
          enabled: false,
          decoration: InputDecoration(
            hintText: 'Tìm xe...',
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            border: InputBorder.none,
            suffixIcon: Icon(Icons.search),
          ),
        ),
      ),
    );
  }

  Widget _rowButtons() {
    return Container(
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(5), color: Colors.teal),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _rowButtonSingleItem(
                image: "assets/images/icons/car.png",
                title: "Ô tô",
                selectedItemTextColor:
                    _rowButtonController == 0 ? Colors.white : Colors.black,
                selectedBgColor:
                    _rowButtonController == 0 ? Colors.teal : Colors.white,
                selectedItemIconColor:
                    _rowButtonController == 0 ? Colors.white : Colors.teal,
                onPressed: () {
                  setState(() {
                    _rowButtonController = 0;
                  });
                }),
            _rowButtonSingleItem(
                image: "assets/images/icons/electric_car.png",
                title: "Ô tô đện",
                selectedItemTextColor:
                    _rowButtonController == 1 ? Colors.white : Colors.black,
                selectedBgColor:
                    _rowButtonController == 1 ? Colors.teal : Colors.white,
                selectedItemIconColor:
                    _rowButtonController == 1 ? Colors.white : Colors.teal,
                onPressed: () {
                  setState(() {
                    _rowButtonController = 1;
                  });
                }),
            _rowButtonSingleItem(
                image: "assets/images/icons/scooter.png",
                title: "Xe máy",
                selectedItemTextColor:
                    _rowButtonController == 3 ? Colors.white : Colors.black,
                selectedBgColor:
                    _rowButtonController == 3 ? Colors.teal : Colors.white,
                selectedItemIconColor:
                    _rowButtonController == 3 ? Colors.white : Colors.teal,
                onPressed: () {
                  setState(() {
                    _rowButtonController = 3;
                  });
                }),
            _rowButtonSingleItem(
                image: "assets/images/icons/electric_scooter.png",
                title: "Xe máy điện",
                selectedItemTextColor:
                    _rowButtonController == 4 ? Colors.white : Colors.black,
                selectedBgColor:
                    _rowButtonController == 4 ? Colors.teal : Colors.white,
                selectedItemIconColor:
                    _rowButtonController == 4 ? Colors.white : Colors.teal,
                onPressed: () {
                  setState(() {
                    _rowButtonController = 4;
                  });
                }),
          ],
        ),
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
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selectedBgColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              color: selectedItemIconColor,
              width: 40,
              height: 40,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: selectedItemTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
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
              }),
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                child: Image.asset(
                                  "assets/images/cars/honda_0.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 18,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10)),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    const Icon(
                                      Icons.star,
                                      color: Colors.teal,
                                    ),
                                    Text(
                                      sliderData.rating,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 135),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: FakeRepository.sliderData
                                      .map((sliderData) {
                                    return Container(
                                      height: 7.0,
                                      width: 7.0,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 2.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _sliderIndex ==
                                                FakeRepository.sliderData
                                                    .indexOf(sliderData)
                                            ? Colors.teal
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
                                width: sizingInformation.localWidgetSize.width *
                                    0.80,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      sliderData.title,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          sliderData.totalStar,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24),
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
  //                 color: Colors.teal,
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
}
