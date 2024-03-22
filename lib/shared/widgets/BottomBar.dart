import 'package:flutter/material.dart';
import 'package:fp_thuexe/pages/journey_history_page.dart';
import 'package:fp_thuexe/pages/anoucement_page.dart';
import 'package:fp_thuexe/pages/home_page.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../pages/info_page.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    JourneyHistoryPage(),
    AnnouncementPage(),
    Information(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        margin: const EdgeInsets.fromLTRB(25, 5, 25, 5),
        // itemPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10), // Adjust padding if needed
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.home, size: 30), // Adjust icon size
            title: Text("Trang chủ", style: TextStyle(fontSize: 14)), // Adjust text style
            selectedColor: Colors.purple,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.map, size: 30),
            title: Text("Hành Trình", style: TextStyle(fontSize: 14)),
            selectedColor: Colors.pink,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.notifications, size: 30),
            title: Text("Thông báo", style: TextStyle(fontSize: 14)),
            selectedColor: Colors.orange,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.person, size: 30),
            title: Text("Thông tin", style: TextStyle(fontSize: 14)),
            selectedColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}
