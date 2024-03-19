import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fp_thuexe/services/AuthService.dart';
import 'package:fp_thuexe/services/ImageService.dart';
import 'package:fp_thuexe/services/UserService.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../models/Vehicle.dart';
import '../services/VehicleService.dart';
import 'confirm_page.dart';

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

  Future<int?> getUserIdFromSharedPrefs() async {
    try {
      final userId = await AuthService.getUserId();
      return userId;
    } catch (error) {
      print('Error retrieving user ID: $error');
      return null; // Handle potential errors
    }
  }



  Future<void> _getImageURLs() async {
    try {
      List<String> imageURLs =
          await ImageService.getAllVehicleImageURLsById(carId);
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
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildCarouselSlider(),
              // _buildTextWithIconRow(
              //     _vehicle != null ? _vehicle!.carName : "...",
              //     _vehicle != null
              //         ? "${_vehicle!.rentalPrice}VNĐ/Ngày"
              //         : "500VNĐ/Ngày"),

              // _buildDescription(
              //     _vehicle != null ? _vehicle!.description : "..."),
              _buildOwnerInfo(_vehicle!),
              _buildCarInfo(_vehicle!),
              // _buildLocationSelection(
              //     _vehicle != null ? _vehicle!.address : "Katowice Airport"),
              _buildOwner(),
              _buildElevatedButton(),
            ],
          ),
        ));
  }

  Widget _buildCarouselSlider() {
    if (_imageURLs.isNotEmpty) {
      return Card(
        margin: EdgeInsets.fromLTRB(0, 12, 0, 12),
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
                      return Expanded(
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
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
      // Placeholder container to hold space when images are not loaded
      return Container(
        height: 300, // Set height of the placeholder container
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.grey[120], // Placeholder color
        ),
      );
    }
  }

// xe giá
  Widget _buildTextWithIconRow(String title, String price) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.teal,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Row(
            children: [
              Text(
                price,
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
  Widget _buildOwnerInfo(Vehicle ownerName) {
    if (ownerName.ownerName != null) {
      return Row(
        children: [
          SizedBox(width: 15,),
          Icon(Icons.account_circle, size: 35.0, color: Colors.orange),
          SizedBox(width: 4.0),
          Text(
            ownerName.carName,
            style: TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.w800),
          ),

      ]);
    } else {
      return SizedBox(); // No owner information available
    }
  }

  Widget _buildCarInfo(Vehicle car) {
    return Container(
      padding: EdgeInsets.all(16.0),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(12.0),
      //   color: Colors.grey[200], // Light background
      // ),
      child: Column(
        children: [
          Divider(height: 4.0, thickness: 1.0, color: Colors.grey[400]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.car_rental_rounded, size: 35.0, color: Colors.red),

              Text(
                car.carName,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(width:280,),
            ],
          ),
          Divider(height: 4.0, thickness: 1.0, color: Colors.grey[400]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Icon(Icons.pending_actions_rounded, size: 35.0, color: Colors.red),
              Text(
                '${car.manufacturer}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 100.0),
              Icon(Icons.model_training, size: 35.0, color: Colors.red),

              Text(
                ' ${car.model}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 20,),
            ],
          ),
          Divider(height: 4.0, thickness: 1.0, color: Colors.grey[400]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.money, size: 30.0, color: Colors.teal),
                  Text(
                    '${car.rentalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20.0,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
              Row(
                children: [

                  Icon(Icons.person, size: 35.0, color: Colors.teal),
                  Text(
                    ' ${car.seating}',
                    style: TextStyle(fontSize: 20.0, color: Colors.black,fontWeight: FontWeight.w800),
                  ),
                  SizedBox(width: 100,),
                ],
              ),
            ],
          ),
          Divider(height: 4.0, thickness: 1.0, color: Colors.grey[400]),

          Row(
            children: [
              Icon(Icons.location_on, size: 35.0, color: Colors.red),
              SizedBox(width: 4.0),

              Text(
                car.address != null ? car.address : "Address not available",
                style: TextStyle(fontSize: 20.0, color: Colors.black,fontWeight: FontWeight.w800),
              ),
            ],
          ),
          Divider(height: 4.0, thickness: 1.0, color: Colors.grey[400]),
          // Optionally add rows for additional details (check if available in Vehicle class)
        ],
      ),
    );
  }
  Widget _buildOwner() {
    return Container(
      margin: EdgeInsets.only(left: 12,right: 12,bottom: 12),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[200], // Light background
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SizedBox(width: 80),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  // Add share functionality
                },
                icon: Icon(
                  Icons.share,
                  size: 20.0,
                  color: Colors.teal,
                ),
              ),
              SizedBox(width: 4.0),
              IconButton(
                onPressed: () {
                  // Add message functionality
                },
                icon: Icon(
                  Icons.message,
                  size: 20.0,
                  color: Colors.teal,
                ),
              ),
              SizedBox(width: 4.0),
              TextButton(
                onPressed: () {
                  // Add phone call functionality
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.phone,
                      size: 20.0,
                      color: Colors.teal,
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      'liên hệ  ',
                      style: TextStyle(fontSize: 16.0, color: Colors.teal, fontWeight: FontWeight.w800),
                    ),
                  ],
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
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            child: Text(
              "Mô tả",
              style: TextStyle(
                  fontSize: 21,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 1),
          Container(
            width: double.infinity,
            child: Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 1),
        ],
      ),
    );
  }

  Widget _buildLocationSelection(String address) {
    return Container(
      height: 300,
      width: double.infinity,
      margin: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Địa chỉ xe",
            style: TextStyle(
              color: Colors.teal,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          Container(
            height: 100,
          )
        ],
      ),
    );
  }

  Widget _buildElevatedButton() {
    return Container(
      margin: EdgeInsets.all(12),
      child: MaterialButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ConfirmPage(_vehicle!)),
          );
        },
        height: 50,
        minWidth: double.infinity,
        color: Colors.teal,
        child: const Text(
          "Thuê ngay",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
    );
  }
}
