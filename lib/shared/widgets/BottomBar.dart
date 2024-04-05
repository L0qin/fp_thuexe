import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fp_thuexe/pages/journey_history_page.dart';
import 'package:fp_thuexe/pages/home_page.dart';
import 'package:fp_thuexe/services/AuthService.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../models/Notification.dart';
import '../../pages/info_page.dart';
import '../../pages/notification_page.dart';
import '../../services/UserService.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _currentIndex = 0;
  int _unreadThongBaoCount = 0; // Track unread ThongBaos

  @override
  void initState() {
    super.initState();
    _fetchAndSetThongBaos();
  }

  List<Widget> _pages = [
    HomePage(),
    JourneyHistoryPage(),
    NotificationPage([]),
    Information(),
  ];

  Future<void> _fetchAndSetThongBaos() async {
    List<ThongBao> ThongBaos = await fetchThongBaos();
    int unreadCount = countUnreadThongBaos(ThongBaos);

    setState(() {
      _unreadThongBaoCount = unreadCount;
      // Assuming ThongBaoPage takes a list of ThongBaos as a parameter
      _pages[2] = NotificationPage(ThongBaos);
    });
  }

  Future<List<ThongBao>> fetchThongBaos() async {
    final int? userId = await AuthService.getUserId();
    if (userId == null || userId == -1) {
      // Handle the case where the user ID is not available or invalid
      print("User ID not found or invalid.");
      return [];
    } else {
      List<ThongBao> ThongBaos =
          (await UserService.getUserNotifications(userId)).cast<ThongBao>();
      return ThongBaos;
    }
  }

  int countUnreadThongBaos(List<ThongBao> ThongBaos) {
    // Assuming ThongBao model has a `trangThaiXem` boolean indicating if it's read
    return ThongBaos
        .where((ThongBao) => ThongBao.trangThaiXem)
        .length;
  }

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
            icon: Icon(Icons.home, size: 30),
            // Adjust icon size
            title: Text("Trang chủ", style: TextStyle(fontSize: 14)),
            // Adjust text style
            selectedColor: Colors.purple,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.map, size: 30),
            title: Text("Hành Trình", style: TextStyle(fontSize: 14)),
            selectedColor: Colors.pink,
          ),
          SalomonBottomBarItem(
            icon: Stack(
              children: <Widget>[
                Icon(Icons.notifications, size: 30), // ThongBao icon
                Positioned(
                  // Unread ThongBao count
                  right: 0,
                  child: _unreadThongBaoCount > 0
                      ? Container(
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            '$_unreadThongBaoCount',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : SizedBox.shrink(),
                ),
              ],
            ),
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
