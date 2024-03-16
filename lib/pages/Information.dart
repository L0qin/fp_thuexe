import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fp_thuexe/models/User.dart';
import 'package:fp_thuexe/services/AuthService.dart';
import 'package:fp_thuexe/services/ImageService.dart';
import 'package:fp_thuexe/services/UserService.dart';


import '../shared/widgets/BottomBar.dart';

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
  late File _profilePicture;
  bool _imagePicked = false;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    User? user = await UserService.getUserById(1);
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
  void _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        _profilePicture = File(file.path!);
        _imagePicked = true;
      });
    } else {
      // Người dùng không chọn ảnh
    }
  }




  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 10.0,
              margin: EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildProfilePicture(),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Chỉnh Sửa'),
                  ),
                  _buildUserInfo(),
                  _buildDivider(),
                  _buildMenuRow(Icons.history, "Đặt xe", "Chuyến đi và lịch sử"),
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
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    return GestureDetector(
      onTap: _pickImage,
      child: CircleAvatar(
        radius: 50,
        backgroundImage: _imagePicked ? FileImage(_profilePicture) : null,
        child: !_imagePicked ? Icon(Icons.add_a_photo, size: 50) : null,
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        SizedBox(height: 8.0),
        Text(_UserNameController.text, style: TextStyle(fontSize: 20.0)),
        SizedBox(height: 5.0),
        Text(_DaddressController.text, style: TextStyle(fontSize: 16.0)),
        SizedBox(height: 5.0),
        Text(_phoneNumberController.text, style: TextStyle(fontSize: 16.0)),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider();
  }

  Widget _buildMenuRow(IconData icon, String label1, [String? label2]) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Icon(icon, size: 30, color: Colors.blue),
          SizedBox(width: 5),
          Text(label1),
          Spacer(),
          if (label2 != null) ...[
            SizedBox(width: 8),
            Text(label2),
          ],
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
