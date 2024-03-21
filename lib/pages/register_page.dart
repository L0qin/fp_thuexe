import 'dart:math';

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import '../services/UserService.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late TextEditingController fullNameController;
  late TextEditingController phoneNumberController;
  late TextEditingController addressController;

  @override
  void initState() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    fullNameController = TextEditingController();
    phoneNumberController = TextEditingController();
    addressController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    fullNameController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void fillWithDummyData() {
    usernameController.text = "testuser${Random().nextInt(100)}";
    passwordController.text = "1";
    confirmPasswordController.text = "1";
    fullNameController.text = "Test User";
    phoneNumberController.text = "1234567890";
    addressController.text = "123 Test Street";
  }

  void register() async {
    try {
      final success = await UserService.registerUser(
        username: usernameController.text,
        password: passwordController.text,
        fullName: fullNameController.text,
        phoneNumber: phoneNumberController.text,
        address: addressController.text,
      );

      if (success) {
        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('Đăng ký thành công'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Show failure dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Registration Failed'),
          content: Text('Tên người dùng bị trùng'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đăng ký"),
        backgroundColor: Colors.teal, // Updated to match the theme
        elevation: 0, // Removes shadow under the app bar
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.teal,
              Colors.teal.withOpacity(0.2),
              // Full-screen soft teal gradient background
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40)
                    .add(EdgeInsets.only(top: 20)), // Added top padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeInUp(
                      duration: Duration(milliseconds: 1500),
                      child: Text(
                        "Tạo tài khoản mới",
                        style: TextStyle(
                          color: Colors.white,
                          // For better contrast on the gradient background
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    BounceInLeft(
                      duration: Duration(milliseconds: 1700),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.teal.withOpacity(0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.teal.withOpacity(0.1),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            )
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            TextFieldContainer(
                                hintText: "Tên đăng nhập",
                                controller: usernameController),
                            TextFieldContainer(
                                hintText: "Mật khẩu",
                                isPassword: true,
                                controller: passwordController),
                            TextFieldContainer(
                                hintText: "Nhập lại mật khẩu",
                                isPassword: true,
                                controller: confirmPasswordController),
                            TextFieldContainer(
                                hintText: "Họ tên",
                                controller: fullNameController),
                            TextFieldContainer(
                                hintText: "Số điện thoại",
                                controller: phoneNumberController),
                            TextFieldContainer(
                                hintText: "Địa chỉ",
                                controller: addressController),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    FadeInUp(
                      duration: Duration(milliseconds: 1800),
                      child: ElevatedButton(
                        onPressed: fillWithDummyData,
                        child: Text(
                          "Test data",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.teal,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    FadeInUp(
                      // Button animation
                      duration: Duration(milliseconds: 1900),
                      child: MaterialButton(
                        onPressed: () {register();},
                        color: Colors.teal,
                        // Button color updated to teal
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        height: 50,
                        child: Center(
                          child: Text(
                            "Đăng ký",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    FadeInUp(
                      duration: Duration(milliseconds: 2000),
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Đã có tài khoản? Đăng nhập ngay",
                            style: TextStyle(
                              color: Colors.teal.shade700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController controller; // Add controller here

  const TextFieldContainer({
    Key? key,
    required this.hintText,
    this.isPassword = false,
    required this.controller, // Require controller in constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.teal.withOpacity(0.3))),
      ),
      child: TextField(
        controller: controller, // Use controller
        obscureText: isPassword,
        decoration: InputDecoration(
          icon: Icon(
            isPassword ? Icons.lock : Icons.person,
            color: Colors.teal,
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade700),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
