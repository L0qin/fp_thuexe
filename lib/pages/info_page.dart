import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fp_thuexe/models/User.dart';
import 'package:fp_thuexe/pages/history_page.dart';
import 'package:fp_thuexe/services/AuthService.dart';
import 'package:fp_thuexe/services/UserService.dart';
import 'package:image_picker/image_picker.dart';

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
    int? userId = await AuthService.getUserId();
    user = await UserService.getUserById(userId!);
    setState(() {
      loadFetchedData(user!);
      _fullNameController.text = user?.fullName ?? "";
      _phoneNumberController.text = user?.phoneNumber ?? "";
      _addressController.text = user?.address ?? "";
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
          title: Text('Sửa thông tin người dùng'),
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
              child: Text('Huỷ'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cập nhật'),
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
        // Assuming you have a method to fetch the updated user details
        User? updatedUser = await UserService.getUserById(user!.userId);
        if (updatedUser != null) {
          setState(() {
            user = updatedUser; // Update the user data in the state
          });
        }

        Navigator.of(context).pop(); // Close the dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Thành công'),
            content: Text('Cập nhật thông tin người dùng thành công.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  // Optionally, if you're navigating or need to refresh the page, do it here
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
          title: Text('Lỗi'),
          content: const Text("Có lỗi khi cập nhật htông tin người dùng"),
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
          colors: [Colors.teal.shade600, Colors.teal.shade200],
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
                        onTap: () {
                          showEditUserForm(context);
                        },
                        child: Text(
                          'Chỉnh Sửa',
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        ),
                      ),
                      _buildDivider(),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HistoryPage()),
                          );
                        },
                        child: _buildMenuRow(
                            Icons.history, "Đặt xe", "Chuyến đi và lịch sử"),
                      ),
                      _buildDivider(),
                      InkWell(
                          onTap: () {},
                          child: _buildMenuRow(
                              Icons.payment, "Phương thức thanh toán")),
                      _buildDivider(),
                      InkWell(
                          onTap: () {},
                          child: _buildMenuRow(
                              Icons.help, "Trợ giúp & yêu cầu hỗ trợ")),
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(50), // Clip to circle
      child: Material(
        // Use Material widget to enable splash effect
        color: Colors.transparent, // Make Material widget transparent
        child: InkWell(
          splashColor: Colors.teal.withOpacity(0.5),
          onTap: () {
            _editProfilePicture();
          },
          child: CircleAvatar(
            radius: 50,
            backgroundImage:
                imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
            child: imageUrl.isEmpty ? Icon(Icons.person, size: 50) : null,
            onBackgroundImageError: (exception, stackTrace) {},
          ),
        ),
      ),
    );
  }

  Future<void> _editProfilePicture() async {
    final ImagePicker _picker = ImagePicker();

    // Function to handle image picking
    Future<void> _pickImage(ImageSource source) async {
      try {
        final XFile? pickedFile = await _picker.pickImage(source: source);
        if (pickedFile != null) {
          // Show the image in a dialog and ask for confirmation
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Save this picture as your profile picture?"),
                content: Image.file(File(pickedFile.path)),
                actions: <Widget>[
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                  TextButton(
                    child: Text("Save"),
                    onPressed: () async {
                      Navigator.of(context).pop(); // Close the dialog
                      bool success = await UserService.updateUserProfilePicture(
                          user!.userId, File(pickedFile.path));
                      if (success) {
                        // Fetch the updated user details from the backend
                        User? updatedUser =
                            await UserService.getUserById(user!.userId);
                        if (updatedUser != null) {
                          setState(() {
                            user =
                                updatedUser; // Assuming 'user' holds the user profile including the image
                            // Consider triggering a UI element that uses the image URL from the 'user' object to refresh
                          });
                          // Consider moving the success dialog outside setState if showDialog causes issues
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Notification"),
                                content: Text(
                                    "Profile picture updated successfully."),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      } else {
                        // Show a failure dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Error"),
                              content:
                                  Text("Failed to update profile picture."),
                              actions: <Widget>[
                                TextButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        print('Error picking image: $e');
      }
    }

    // Consider adding logic here to trigger _pickImage with the desired ImageSource (e.g., camera, gallery)

    // Show the bottom sheet/dialog for image source selection
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Gallery'),
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
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
    return Padding(
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
    );
  }
}
