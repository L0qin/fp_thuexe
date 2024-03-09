import 'package:flutter/material.dart';
import 'package:fp_thuexe/pages/JourneyHistory.dart';
import 'package:fp_thuexe/pages/anoucement.dart';
import 'package:fp_thuexe/pages/home_page.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../pages/Information.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    // HomePage content directly included here
    HomePage(),
    JourneyHistoryPage(),
    AnnouncementPage(),
    Information()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        margin: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Trang chủ"),
            selectedColor: Colors.purple,
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: const Icon(Icons.map),
            title: const Text("Hành Trình"),
            selectedColor: Colors.pink,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: const Icon(Icons.notifications),
            title: const Text("Thông báo"),
            selectedColor: Colors.orange,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text("Thông tin"),
            selectedColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}
