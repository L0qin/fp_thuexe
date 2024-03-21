import 'dart:async';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fp_thuexe/models/Vehicle.dart';
import 'package:fp_thuexe/pages/login_page.dart';
import 'package:fp_thuexe/pages/search_page.dart';
import 'package:fp_thuexe/services/AuthService.dart';
import 'package:fp_thuexe/services/UserService.dart';
import 'package:fp_thuexe/services/VehicleService.dart';

import '../models/User.dart';
import '../services/ImageService.dart';
import 'post_car_page.dart';
import 'car_detail_page.dart';

class HomePage extends StatefulWidget {
  static const title = 'Thuê xe';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  bool _isLoggedIn = false;
  User? _user;
  late Timer _timer;
  late Future<List<Vehicle>> _vehiclesFuture;

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _checkLoginStatus();
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Check login status when the app is resumed
      _checkLoginStatus();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _vehiclesFuture = VehicleService.getAllVehicles();
    _checkLoginStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer.cancel();
    super.dispose();
  }

  void _checkLoginStatus() async {
    bool loggedIn = await AuthService.getToken() != null;
    setState(() {
      _isLoggedIn = loggedIn;
    });
    if (loggedIn) {
      int? userId = await AuthService.getUserId();
      if (userId != null) {
        User? fetchedUser = await UserService.getUserById(userId);
        setState(() {
          _user = fetchedUser;
          _timer.cancel();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.grey, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 30),
                _headerWidget(),
                const SizedBox(height: 10),
                _searchWidget(),
                const SizedBox(height: 15),
                _buildHeader('Các hãng & đối tác'),
                _buildBrandList(context),
                _buildViewAllButton(),
                const SizedBox(height: 4),
                _buildHeader('Thuê nhiều'),
                _buildCarList(),
                const SizedBox(height: 4),
                _buildHeader('News'),
                _buildNewCar(),
                const SizedBox(height: 10),
                _buildHeaderNoExpand('Bạn có xe nhàn rỗi? Đăng ngay!'),
                _buildPostCar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerWidget() {
    String buttonText = _isLoggedIn ? "Đăng xuất" : "Đăng nhập";

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (_isLoggedIn)
            FutureBuilder<User?>(
              future: _getUserFuture(), // Adjust this method to fetch the user
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircleAvatar(
                    radius: 22.5,
                    backgroundColor: Colors.grey[300],
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  return CircleAvatar(
                    radius: 22.5,
                    backgroundImage:
                        NetworkImage(snapshot.data!.profilePicture),
                    backgroundColor: Colors.grey[300],
                  );
                } else {
                  return CircleAvatar(
                    radius: 22.5,
                    backgroundImage: AssetImage('assets/images/icons/user.png'),
                    backgroundColor: Colors.grey[300],
                  );
                }
              },
            )
          else
            CircleAvatar(
              radius: 22.5,
              backgroundImage: AssetImage('assets/images/icons/user.png'),
              backgroundColor: Colors.grey[300],
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Location",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(height: 4),
                  if (_isLoggedIn)
                    FutureBuilder<User?>(
                      future: _getUserFuture(),
                      // Adjust this method to fetch the user
                      builder: (context, snapshot) {
                        String address = snapshot.hasData &&
                                snapshot.data!.address.isNotEmpty
                            ? snapshot.data!.address
                            : "Chưa đăng nhập";
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              address,
                              style: TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Icon(Icons.arrow_drop_down, color: Colors.teal),
                          ],
                        );
                      },
                    )
                  else
                    Text(
                      "Chưa đăng nhập",
                      style: TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ),
          _buildLoginLogoutButton(buttonText),
        ],
      ),
    );
  }

  Future<User?> _getUserFuture() async {
    int? userId = await AuthService.getUserId();
    if (userId != null) {
      return UserService.getUserById(userId);
    }
    return null; // Or handle this case as needed
  }

  Widget _buildLoginLogoutButton(String buttonText) {
    return ButtonTheme(
      minWidth: 80,
      height: 36,
      child: MaterialButton(
        onPressed: () async {
          if (_isLoggedIn) {
            // Confirm log out dialog
            bool confirmLogout = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Xác nhận đăng xuất'),
                    content: Text('Bạn có chắc chắn muốn đăng xuất?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('Không'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text('Có'),
                      ),
                    ],
                  ),
                ) ??
                false;

            if (confirmLogout) {
              await AuthService
                  .logout(); // Assumes logout method sets internal state and clears any auth tokens
              setState(() {
                _isLoggedIn = false;
                _user = null; // Ensure user info is cleared on logout
              });
            }
          } else {
            // Navigate to the login page and then check login status again
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      LoginPage()), // LoginPage() must be defined in your app
            ).then((_) => _checkLoginStatus());
          }
        },
        color: Colors.teal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Text(
          buttonText,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
    );
  }

//Search
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

//Brands
  Widget _buildHeader(String title) {
    return Container(
      height: 30,
      width: double.infinity,
      margin: EdgeInsets.only(left: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: Colors.teal[700],
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(
            width: 100,
          ),
          GestureDetector(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 12, 0),
                child: Text(
                  'Xem tất cả',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              )),
        ],
      ),
    );
  }

//Brand
  Widget _buildLogoBrands(String brandName) {
    if (brandName == null) {
      return Container();
    }
    return InkWell(
      onTap: () {
        // Handle logo tap event (optional)
        print("Logo $brandName is tapped!");
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        width: 80,
        height: 70,
        decoration: BoxDecoration(
          //color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Image.asset('assets/images/brands/$brandName.png'),
      ),
    );
  }

  Widget _buildBrandList(BuildContext context) {
    List<String> brandNames = [
      'honda',
      'huydai',
      'landrover',
      'cheverolet',
      'bmw',
      'audi',
      'huydai'
    ]; // Sample brand names

    return CarouselSlider(
      items: brandNames.map((name) => _buildLogoBrands(name ?? '')).toList(),
      options: CarouselOptions(
        height: 70,
        // Bạn có thể điều chỉnh chiều cao theo ý muốn
        viewportFraction: 1 / 5,
        // Hiển thị 50% tổng số item
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        pauseAutoPlayOnTouch: true,
        onPageChanged: (index, reason) {},
      ),
    );
  }

  Widget _buildViewAllButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: MaterialButton(
        onPressed: () {},
        child: Text('Xem tất cả'),
      ),
    );
  }

  Widget _buildCarList() {
    return FutureBuilder<List<Vehicle>>(
      future: _vehiclesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final List<Vehicle> vehicles = snapshot.data ?? [];
          return CarouselSlider(
            items: vehicles.map((vehicle) {
              return _buildCarItem(vehicle);
            }).toList(),
            options: CarouselOptions(
              height: 175,
              viewportFraction: 2 / 4,
              enableInfiniteScroll: true,
            ),
          );
        }
      },
    );
  }

  Widget _buildCarItem(Vehicle vehicle) {
    return FutureBuilder<String>(
      future: ImageService.getVehicleMainImageURLById(vehicle.carId),
      builder: (context, snapshot) {
        final defaultImage = 'assets/images/cars/land_rover_0.png';
        final imageUrl = snapshot.data ?? defaultImage;
        return Container(
          width: 230,
          margin: EdgeInsets.all(2.5),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: <Widget>[
              Image.network(
                imageUrl,
                width: 100,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    defaultImage,
                    width: 100,
                  );
                },
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      vehicle.carName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      vehicle.model,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${vehicle.rentalPrice}d/Ngày',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildRentButton(vehicle),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNewCar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      // Adjust the horizontal padding as needed
      child: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white10, // Background color for the main container
            borderRadius: BorderRadius.circular(
                10), // Border radius for the main container
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
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
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
              SizedBox(width: 10),
              // Adjust the spacing between the text content and image
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  // Border color for the image frame
                  borderRadius: BorderRadius.circular(10),
                  // Border radius for the image frame
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  // Clip the image with border radius
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

  Widget _buildHeaderNoExpand(String title) {
    return Container(
      height: 30,
      width: double.infinity,
      margin: EdgeInsets.only(left: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: Colors.teal[700],
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCar() {
    return Container(
      margin: EdgeInsets.all(12.0),
      width: double.infinity,
      height: 200.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        image: DecorationImage(
          image: AssetImage('assets/images/background2.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: ElevatedButton(
              onPressed: () {
                if (!_isLoggedIn) {
                  // Show dialog if user is not logged in
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Bạn chưa đăng nhập"),
                        content: Text("Bạn có muốn đăng nhập để tiếp tục?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text("Hủy"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            },
                            child: Text("Đồng ý"),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // User is logged in, navigate to PostCar screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PostCar()),
                  );
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 17, vertical: 12),
                child: Text(
                  'Đăng xe ngay',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.withOpacity(0.95),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRentButton(Vehicle vehicle) {
    return MaterialButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailCar(vehicle),
          ),
        );
      },
      minWidth: 100,
      height: 40,
      splashColor: Colors.white12,
      color: Colors.teal,
      child: const Text(
        "Thuê Ngay",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
