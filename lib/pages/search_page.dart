import 'package:flutter/material.dart';
import 'package:fp_thuexe/pages/detailCar.dart';
import 'package:fp_thuexe/services/ImageService.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../models/Vehicle.dart';
import '../services/VehicleService.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<List<Vehicle>> _searchedVehicles;

  @override
  void initState() {
    super.initState();
    _searchedVehicles = VehicleService.getAllVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tìm kiếm xe",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          return Column(
            children: [
              _searchBar(),
              _cardTimeWidget(sizingInformation),
              _searchListWidget(),
            ],
          );
        },
      ),
    );
  }

  Widget _searchListWidget() {
    return Expanded(
      child: FutureBuilder<List<Vehicle>>(
        future: _searchedVehicles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Vehicle vehicle = snapshot.data![index];
                return VehicleItem(
                  carId: vehicle.carId,
                  carName: vehicle.carName,
                  shortAddress: vehicle.address,
                  rentPrice: vehicle.rentalPrice.toDouble(),
                );
              },
            );
          }
        },
      ),
    );

  }

  Widget _searchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0).copyWith(bottom: 5.0),

        child: TextField(
        onChanged: (value) {
          // Update searched vehicles based on search text
          if (value.isEmpty) {
            setState(() {
              _searchedVehicles = VehicleService.getAllVehicles();
            });
          } else {
            setState(() {
              _searchedVehicles = VehicleService.searchVehicles(value);
            });
          }
        },
        decoration: InputDecoration(
          hintText: 'Tìm xe...',
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: const Icon(Icons.search, color: Colors.teal),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.teal),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.teal),
          ),
        ),
      ),
    );
  }

  Widget _cardTimeWidget(SizingInformation sizingInformation) {
    return Container(
      height: 101,
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: () {
                  // Handle onTap for the first card
                },
                splashColor: Colors.teal,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 101,
                  width: sizingInformation.localWidgetSize.width * 0.45,
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "10",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Sunday, May 25",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            "Time: 10:00",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // Handle onTap for the second card
                },
                splashColor: Colors.teal,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 101,
                  width: sizingInformation.localWidgetSize.width * 0.45,
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "11",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Sunday, Nov 26",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            "Time: 10:00",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
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
                color: Colors.teal,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: const Icon(
                Icons.arrow_forward,
                size: 24,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class VehicleItem extends StatelessWidget {
  final int carId;
  final String carName;
  final String shortAddress;
  final double rentPrice;

  VehicleItem({
    required this.carId,
    required this.carName,
    required this.shortAddress,
    required this.rentPrice,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: ImageService.getVehicleImageURLById(carId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final String imageUrl = snapshot.data ?? '';
          return Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Colors.teal, width: 1.0),
                  // Thin border
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(12.0),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailCar(carId),
                        ),
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 165.0,
                          // Adjusted width of the image container
                          height: 140.0,
                          // Adjusted height of the image container
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12.0),
                              bottomLeft: Radius.circular(12.0),
                            ),
                            child: imageUrl.isNotEmpty
                                ? Image.network(
                                    imageUrl,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                      Icons.directions_car,
                                      size: 50,
                                      color: Colors.teal,
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(
                                    Icons.directions_car,
                                    size: 50,
                                    color: Colors.teal,
                                  ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  child: Text(
                                    carName,
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal, // Title color
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    Icon(Icons.location_on, color: Colors.teal),
                                    // Map pin icon
                                    SizedBox(width: 4.0),
                                    Text(
                                      shortAddress,
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 15,
                right: 20,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0),
                    ),
                  ),
                  child: Text(
                    '${rentPrice.toStringAsFixed(0)}\n/Ngày',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
