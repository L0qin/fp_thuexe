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
  var unreadThongBaoCount;

  BottomBar(this.unreadThongBaoCount, {super.key});

  @override
  _BottomBarState createState() => _BottomBarState(unreadThongBaoCount);
}

class _BottomBarState extends State<BottomBar> {
  int _currentIndex = 0;
   int _unreadThongBaoCount=100;

  _BottomBarState(this._unreadThongBaoCount);

  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _pages = [
    HomePage(),
    JourneyHistoryPage(),
    NotificationPage([]),
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
