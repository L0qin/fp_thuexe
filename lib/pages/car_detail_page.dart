import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fp_thuexe/models/User.dart';
import 'package:fp_thuexe/services/AuthService.dart';
import 'package:fp_thuexe/services/ImageService.dart';
import 'package:fp_thuexe/services/UserService.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../models/Vehicle.dart';
import '../services/VehicleService.dart';
import 'confirm_page.dart';

class DetailCar extends StatefulWidget {
  DetailCar(this.vehicle);

  Vehicle vehicle;

  @override
  State<DetailCar> createState() => _DetailCarState(vehicle);
}

class _DetailCarState extends State<DetailCar> {
  int _sliderIndex = 0;
  late Vehicle vehicle;
  late Future<List<String>> _imagesFuture;
  late Future<Vehicle?> _vehicleFuture;
  late Future<User?> _userFuture;

  _DetailCarState(this.vehicle);

  @override
  void initState() {
    _imagesFuture = ImageService.getAllVehicleImageURLsById(vehicle!.carId);
    _vehicleFuture = VehicleService.getVehicleById(vehicle!.carId);
    _userFuture = UserService.getUserById(vehicle.ownerId);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Chi tiết xe",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.teal,
        ),
        body: SingleChildScrollView(
            child: Container(
          margin: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildCarouselSlider(),
              _buildOwnerInfo(),
              _buildCarInfo(),
              _buildContactRow(),
              _buildElevatedButton(),
            ],
          ),
        )));
  }

  Widget _buildCarouselSlider() {
    return FutureBuilder<List<String>>(
      future: _imagesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a placeholder or loading indicator while data is loading
          return Container(
            height: 300,
            // Set height of the placeholder container
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.grey.shade300, // Placeholder color
            ),
            alignment: Alignment.center,
            child: CircularProgressIndicator(), // Loading indicator
          );
        }
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          // Data is loaded, build the carousel with images
          List<String> imageURLs = snapshot.data!;
          return _buildImageCarousel(
              imageURLs); // Extract the existing carousel code into this method
        } else {
          // Handle no data or error state
          return Container(
            height: 300,
            // Set height for error or no data state
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.grey.shade200, // Placeholder color
            ),
            alignment: Alignment.center,
            child:
                Text('No images available'), // Show an error or no data message
          );
        }
      },
    );
  }

  Widget _buildImageCarousel(List<String> imageURLs) {
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
                  items: imageURLs.map((imageUrl) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                        );
                      },
                    );
                  }).toList(),
                ),
                Positioned(
                  bottom: 16.0,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(imageURLs.length, (index) {
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
  }

  Widget _buildOwnerInfo() {
    return Container(
      margin: const EdgeInsets.all(15),
      child: FutureBuilder<User?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (snapshot.hasData && snapshot.data != null) {
            User userOwner = snapshot.data!;
            return Card(
              elevation: 8, // Increased elevation for depth
              shadowColor: Colors.teal.shade100, // Soft shadow color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    20), // More pronounced rounded corners
              ),
              child: InkWell(
                onTap: () {},
                splashColor: Colors.teal.withAlpha(40),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35, // Slightly larger avatar
                        backgroundImage: NetworkImage(userOwner.profilePicture),
                        onBackgroundImageError: (exception, stackTrace) => Icon(
                          Icons.account_circle,
                          size: 70,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      SizedBox(width: 20), // Increased spacing
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userOwner.fullName,
                              style: TextStyle(
                                fontSize: 20.0, // Larger font size
                                fontWeight: FontWeight.bold,
                                color: Colors
                                    .teal.shade700, // Darker shade for text
                              ),
                            ),
                            SizedBox(height: 5),
                            // Reduced height for a compact look
                            Row(
                              children: [
                                Icon(Icons.pin_drop,
                                    color: Colors.teal.shade600, size: 20),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    userOwner.address,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.grey.shade600),
                                    // Muted color for the address
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Text("No user data available");
          }
        },
      ),
    );
  }

  Widget _buildCarInfo() {
    return FutureBuilder<Vehicle?>(
      future: _vehicleFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading vehicle details'));
        } else if (snapshot.hasData && snapshot.data != null) {
          Vehicle vehicle = snapshot.data!;
          return Card(
            elevation: 6,
            margin: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _infoRow(Icons.directions_car, "Tên xe", vehicle.carName, isTitle: true),
                  Divider(),
                  _infoRow(Icons.category, "Model", vehicle.model),
                  _infoRow(Icons.account_balance, "Hãng", vehicle.manufacturer),
                  _infoRow(Icons.attach_money, "Giá thuê/ngày", "${vehicle.rentalPrice.toStringAsFixed(2)} VND"),
                  _infoRow(Icons.event_seat, "Số chỗ", "${vehicle.seating} chỗ"),
                  _buildDescription(vehicle.description)
                ],
              ),
            ),
          );
        } else {
          return Center(child: Text('Danh sách rỗng'));
        }
      },
    );
  }

  Widget _buildDescriptionCard(String description) {
    // Calculate height based on description length; this is a simple approximation.
    double height = 100 + (description.length / 20 * 10);
    height = height.clamp(100.0, 300.0); // Ensure height is within reasonable bounds.

    return Container(
      padding: EdgeInsets.all(12), // Padding on all sides
      height: height,
      child: Card(
        elevation: 5, // Adds shadow under the card for a lifted effect
        child: Padding(
          padding: EdgeInsets.all(12), // Padding inside the card
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.description, color: Colors.blueAccent), // Example icon
              SizedBox(width: 10), // Space between icon and text
              Expanded(
                child: SingleChildScrollView( // Allows for scrolling if text is long
                  child: Text(
                    description,
                    style: TextStyle(fontSize: 16), // Adjust text style as needed
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _infoRow(IconData icon, String title, String value, {bool isTitle = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.teal.shade400),
            SizedBox(width: 10),
            Text(title, style: TextStyle(fontWeight: isTitle ? FontWeight.bold : FontWeight.normal, fontSize: isTitle ? 20 : 16)),
          ],
        ),
        Text(value, style: TextStyle(color: Colors.black54, fontSize: 16)),
      ],
    );
  }



  Widget _buildContactRow() {
    return Container(
      margin: EdgeInsets.only(left: 12, right: 12, bottom: 12),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[200], // Light background
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.teal,
                          fontWeight: FontWeight.w800),
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
          if (vehicle != null) {
            // Ensure _vehicle is not null
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ConfirmPage(vehicle!)),
            );
          } else {
            print("Vehicle information is not loaded yet.");
          }
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
