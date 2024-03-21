import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fp_thuexe/models/User.dart';
import 'package:fp_thuexe/services/UserService.dart';

import '../services/ImageService.dart';

class Information extends StatefulWidget {
  const Information({super.key});

  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information> {
  TextEditingController _UserNameController = TextEditingController();
  TextEditingController _DaddressController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _profilePictureController = TextEditingController();
  User? user = User.unLoadedUser();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    user = await UserService.getUserById(1);
    setState(() {
      loadFetchedData(user!);
    });
  }

  void loadFetchedData(User user) {
    _UserNameController.text = user.username;
    _DaddressController.text = user.address;
    _phoneNumberController.text = user.phoneNumber?.toString() ?? '';
    _profilePictureController.text = user.profilePicture;
  }

  void showEditUserForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit User'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _fullNameController,
                  decoration: InputDecoration(hintText: 'Full Name'),
                ),
                TextField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(hintText: 'Phone Number'),
                ),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(hintText: 'Address'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Update'),
              onPressed: () {
                _updateUser(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _updateUser(BuildContext context) async {
    try {
      final success = await UserService.updateUser(
        user!.userId,
        _fullNameController.text,
        _phoneNumberController.text,
        _addressController.text,
      );

      if (success) {
        Navigator.of(context).pop(); // Close the dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('User updated successfully.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close the dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(e.toString()),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.teal.shade700, Colors.teal.shade200],
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                color: Colors.white.withOpacity(0.9),
                elevation: 12.0,
                margin: EdgeInsets.symmetric(horizontal: 18.0, vertical: 50.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildProfilePicture(),
                      _buildUserInfo(),
                      GestureDetector(
                        onTap: () {showEditUserForm(context);},
                        child: Text(
                          'Chỉnh Sửa',
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        ),
                      ),
                      _buildDivider(),
                      _buildMenuRow(
                          Icons.history, "Đặt xe", "Chuyến đi và lịch sử"),
                      _buildDivider(),
                      _buildMenuRow(Icons.payment, "Phương thức thanh toán"),
                      _buildDivider(),
                      _buildMenuRow(Icons.help, "Trợ giúp & yêu cầu hỗ trợ"),
                      _buildDivider(),
                      _buildMenuRow(Icons.language, "Thay đổi ngôn ngữ"),
                      _buildDivider(),
                      _buildMenuRow(Icons.notifications, "Thông báo"),
                      _buildDivider(),
                      _buildMenuRow(Icons.settings, "Quản lý Tài Khoản"),
                      _buildDivider(),
                      _buildMenuRow(Icons.receipt, "Quy chế"),
                      _buildDivider(),
                      _buildMenuRow(Icons.security, "Bảo mật & đều khoảng"),
                      _buildDivider(),
                      _buildMenuRow(Icons.star, "Đáng gia ứng dụng"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    final String imageUrl = user!.profilePicture ?? "";
    return CircleAvatar(
      radius: 50,
      backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
      child: imageUrl.isEmpty ? Icon(Icons.person, size: 50) : null,
      onBackgroundImageError: (exception, stackTrace) {},
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        SizedBox(height: 12.0),
        Text(user!.fullName ?? "Chưa Đăng Nhập",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade800, // Adds a touch of the primary color
            )),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, color: Colors.teal.shade600),
            SizedBox(width: 5.0),
            Text(user!.address ?? "",
                style: TextStyle(fontSize: 18.0, color: Colors.grey.shade600)),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.phone, color: Colors.teal.shade600),
            SizedBox(width: 5.0),
            Text(user!.phoneNumber ?? "",
                style: TextStyle(fontSize: 18.0, color: Colors.grey.shade600)),
          ],
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.teal.shade100);
  }

  Widget _buildMenuRow(IconData icon, String label1, [String? label2]) {
    return InkWell(
      onTap: () {}, // Placeholder function for onTap action
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          // Align items to the start of the row
          children: [
            Icon(icon, size: 30, color: Colors.teal),
            // Icon with teal color
            SizedBox(width: 10),
            // Positive width for spacing
            Expanded(
              // Wrap Text with Expanded to prevent overflow
              child: Text(
                label1,
                style: TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis, // Prevent text overflow
              ),
            ),
            if (label2 != null) ...[
              Expanded(
                // Also wrap the optional text with Expanded
                child: Text(
                  label2,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  overflow:
                      TextOverflow.ellipsis, // Handle overflow for second label
                ),
              ),
            ],
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.teal),
            // Forward icon
          ],
        ),
      ),
    );
  }
}
