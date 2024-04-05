import 'package:flutter/material.dart';

import '../models/Notification.dart';
import '../services/UserService.dart';

class NotificationPage extends StatefulWidget {
  var notifications;

  NotificationPage(this.notifications);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  _NotificationPageState();
  List<ThongBao> notifications = [];

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      int userId = 1; // Example user ID, replace with actual user ID
      notifications = await UserService.getUserNotifications(userId);
      setState(() {});
    } catch (e) {
      print("Error fetching notifications: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 100,
      centerTitle: true,
      elevation: 4,
      backgroundColor: Colors.teal,
      title: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Text('Notifications',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      actions: [_buildActions(context)],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: IconButton(
        icon: Icon(Icons.delete_outline, color: Colors.red),
        onPressed: () => _showClearAllDialog(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) => _buildListItem(context, index),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    final item = notifications[index];
    return Dismissible(
      key: Key(item.maThongBao.toString()),
      // Use the notification ID as a unique key
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20.0),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm"),
              content: const Text("Are you sure you wish to delete this item?"),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("DELETE")),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("CANCEL"),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        setState(() {
          notifications.removeAt(index);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("${item.tieuDe} dismissed"),
              behavior: SnackBarBehavior.floating),
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(''),
          child: Icon(Icons.doorbell),
        ),
        title: Text(item.tieuDe),
        subtitle: Text(item.noiDung),
        onTap: () => _showBottomSheet(context, item),
      ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Thông báo"),
          content: Text("Xoá tất cả thông báo?."),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: Text("Clear All", style: TextStyle(color: Colors.red)),
              onPressed: () {
                setState(() {
                  notifications.clear;
                });
                Navigator.of(context).pop(); // Dismiss the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("All notifications cleared")));
              },
            ),
          ],
        );
      },
    );
  }

  void _showBottomSheet(BuildContext context, ThongBao notification) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                notification.tieuDe,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal),
              ),
              SizedBox(height: 10),
              Text(
                "Chi Tiết:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                notification.noiDung,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              if (notification.tenLoai.isNotEmpty) ...[
                Text(
                  "Loại thông báo: ${notification.tenLoai}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
              ],
              if (notification.moTa.isNotEmpty) ...[
                Text(
                  "${notification.moTa}",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
              ],
              Text(
                "Ngày nhận: ${notification.ngayTao.toLocal().toString().split(' ')[0]}", // Display only the date part
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Đóng", style: TextStyle(fontSize: 16)),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.teal,
                    disabledForegroundColor: Colors.grey.withOpacity(0.38),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
