import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fp_thuexe/pages/login_page.dart';
import 'package:fp_thuexe/pages/search_page.dart';
import 'package:fp_thuexe/services/AuthService.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  static const title = 'Thuê xe';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoggedIn = false;
  bool _isRenting = false;

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
                _headerWidget(),
                const SizedBox(height: 10),
                _searchWidget(),
                const SizedBox(height: 15),
                _buildHeader('Top Brands'),
                _buildBrandList(context),
                _buildViewAllButton(),
                const SizedBox(height: 4),
                _buildHeader('Most Rented'),
                _buildCarList(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
//Login
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
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              }
              setState(() {
                _isLoggedIn = !_isLoggedIn;
              });
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
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: Colors.blue[700],
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(width: 370,),
          GestureDetector(
            onTap: () {},
            child: Text(
              'View All',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
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
    List<String> brandNames = ['honda', 'bmw', 'huydai', 'landrover', 'cheverolet', 'bmw', 'bmw', 'audi','huydai','huydai']; // Sample brand names

      return CarouselSlider(
      items: brandNames.map((name) => _buildLogoBrands(name ?? '')).toList(),
    options: CarouselOptions(
    height: 70, // Bạn có thể điều chỉnh chiều cao theo ý muốn
    viewportFraction:1/5, // Hiển thị 50% tổng số item
    enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        pauseAutoPlayOnTouch: true,
        onPageChanged: (index, reason) {
          // Xử lý khi trang thay đổi (nếu cần)
        },

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
    return CarouselSlider(
      items: [
        _buildCarItem('Sport', 'Hyundai i30 N 2021', 20),
        _buildCarItem('Economy', 'Volkswagen Golf EVO 2022', 15),
        _buildCarItem('Economy', 'Volkswagen Golf EVO 2022', 15), _buildCarItem('Economy', 'Volkswagen Golf EVO 2022', 15),
        _buildCarItem('Economy', 'Volkswagen Golf EVO 2022', 15),

        // Thêm các item khác cho các mẫu xe khác
      ],
      options: CarouselOptions(
        height: 175, // Chiều cao của CarouselSlider
        viewportFraction: 2/4, // Hiển thị 80% tổng số item
        enableInfiniteScroll: true, // Bật cuộn vô hạn
      ),
    );
  }


  Widget _buildCarItem(String type, String name, int price) {
    return Container(
      width: 230,
      margin: EdgeInsets.all(5),
       padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: <Widget>[
          Image.asset(
            'assets/images/cars/land_rover_0.png',
            width: 100,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  type,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  '\$$price/per day',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                _buildRentButton(price),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRentButton(int price) {
    return MaterialButton(
      onPressed: () {
        if (_isRenting) {
          // Xử lý việc hủy thuê xe
          setState(() {
            _isRenting = false;
          });
        } else {
          // Xử lý việc thuê xe
          // Hiển thị thông tin chi tiết, xác nhận
          setState(() {
            _isRenting = true;
          });
        }
      },
      minWidth: 100,
      height: 40,
      splashColor: Colors.white12,
      color: _isRenting ? Colors.grey : Colors.teal,
      child: Text(
        _isRenting ? "Đã Thuê" : "Thuê Xe",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

}
