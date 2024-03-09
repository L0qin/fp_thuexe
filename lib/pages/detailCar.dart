import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fp_thuexe/repository/repository.dart';
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
        // appBar: AppBar(
        //   title: Text("Kia"),
        // ),
        body: ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return Container(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(12.0)),
              _sliderWidgetCard(sizingInformation),
              Card(
                color: Colors.white,
                // Màu của thẻ
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),

                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(

                    children: [
                     Row(
                       children: [
                         Expanded(
                           child: Center(
                             child: SizedBox(
                               width: 300,
                               child:  CircleAvatar(
                                 radius: 100,
                                 backgroundImage: AssetImage('assets/images/icons/user.png'),
                               ),
                               // child: ClipRRect(
                               //   borderRadius: BorderRadius.circular(500),
                               //   child: Image.network(
                               //     cocktail.strDrinkThumb,
                               //     loadingBuilder: (BuildContext context, Widget child,
                               //         ImageChunkEvent? loadingProgress) {
                               //       if (loadingProgress == null) {
                               //         return child;
                               //       } else {
                               //         return Center(
                               //           child: CircularProgressIndicator(
                               //             value: loadingProgress.expectedTotalBytes != null
                               //                 ? loadingProgress.cumulativeBytesLoaded /
                               //                 (loadingProgress.expectedTotalBytes ?? 1)
                               //                 : null,
                               //           ),
                               //         );
                               //       }
                               //     },
                               //   ),
                               // ),
                             ),
                           ),
                         ),
                       ],
                     ),
                      Row(
                        children: [
                          SizedBox(
                            width: 110,
                            child: Text('Hãng Xe',
                                style: TextStyle(
                                    fontSize: 25, color: Colors.green)),
                          ),
                          Expanded(
                            child: Text("Kia Morning",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 110,
                            child: Text('Địa chỉ',
                                style: TextStyle(
                                    fontSize: 25, color: Colors.green)),
                          ),
                          Expanded(
                            child: Text("180 Cao Lỗ",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 90,
                            child: Text('Cho Thuê Xe',
                                style: TextStyle(
                                    fontSize: 25, color: Colors.green)),
                          ),
                          Expanded(
                            child: TextField(
                                controller: _soNgay,
                                decoration: InputDecoration(hintText: "Ngày"),
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black)),
                          ),
                          Text("Ngày"),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 90,
                            child: Text('Thời Hạn',
                                style: TextStyle(
                                    fontSize: 25, color: Colors.green)),
                          ),
                          Expanded(
                            child: TextField(
                                controller: _soNgay,
                                decoration: InputDecoration(hintText: "Ngày"),
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black)),
                          ),
                          Text("Ngày"),
                        ],
                      ),
                      SizedBox(height: 8,),
                      Row(
                        children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [  Text("Mô Tả ",style: TextStyle(
                                  fontSize: 25, color: Colors.green)),],
                            ),
                            Row(
                              children: [
                                Text("Xe phóng như cái máy bay ",style: TextStyle(
                                    fontSize: 18, color: Colors.black)),
                              ],
                            )
                          ],
                        )
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(),
                      Row(
                        children: [
                          Padding(padding: EdgeInsets.only(right: 450)),
                          Expanded(
                            child: TextField(
                                controller: _soNgay,
                                decoration: InputDecoration(hintText: "VNĐ"),
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black)),
                          ),
                          Text("VNĐ/Ngày"),
                        ],
                      ),

                    ],

                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Card(
                      margin: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ClipRRect(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(12.0)),
                        child: Image.asset(
                          "assets/images/icons/google-maps-01.jpg",
                          fit: BoxFit.cover,
                          width: 1900,
                          height: 350,
                        ),

                      ),
                    )
                  ],
                ),
              ),
              ElevatedButton(onPressed:() {

              },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blue,  // Text color
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Button border radius
                    ),
                    elevation: 4,
                  ),
                  child: Text("Thuê Xe",style: TextStyle(color: Colors.black,fontSize: 35,fontWeight: FontWeight.bold),)),

            ],
          ),
        );
      },
    ));
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
                                  "assets/images/cars/kiamorning.jpg",
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
                                      color: Colors.red,
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
}
