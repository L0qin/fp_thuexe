import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:fp_thuexe/pages/register_page.dart';
import 'package:fp_thuexe/services/AuthService.dart';

import '../models/User.dart';
import '../services/UserService.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    String username = _usernameController.text.trim() ?? "";
    String password = _passwordController.text.trim() ?? "";

    try {
      String? token = await AuthService.login(username, password);

      if (token != null) {
        Navigator.pop(context);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Sai thông tin đăng nhập'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Handle network errors separately
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Lỗi: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context)
        .size
        .height; // Added to adjust layout dynamically

    return Scaffold(
      appBar: AppBar(
        title: const Text("Đăng nhập"),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: screenHeight * 0.35, // Make the container responsive
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -100,
                    height: screenHeight * 0.35, // Adjusted for dynamic sizing
                    width: width,
                    child: FadeInUp(
                      duration: const Duration(seconds: 1),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.5),
                          image: DecorationImage(
                            image: const AssetImage(
                                'assets/images/background.png'),
                            fit: BoxFit.cover,
                            // Changed to cover to better fit different screen sizes
                            colorFilter: ColorFilter.mode(
                              Colors.teal.withOpacity(0.5),
                              BlendMode.srcATop,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    height: screenHeight * 0.35, // Adjusted for dynamic sizing
                    width: width + 20, // Minor adjustment for edge bleed
                    child: FadeInDown(
                      duration: const Duration(milliseconds: 1000),
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/background2.png'),
                            fit: BoxFit.cover, // Adjusted to cover
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeInUp(
                    duration: const Duration(milliseconds: 1500),
                    child: const Text(
                      "Đăng Nhập",
                      style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1700),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(
                          color: const Color.fromRGBO(196, 135, 198, .3),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(196, 135, 198, .3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          )
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          TextFieldContainer(
                              controller: _usernameController,
                              hintText: "Tên đăng nhập"),
                          TextFieldContainer(
                              controller: _passwordController,
                              hintText: "Mật khẩu",
                              obscureText: true),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1700),
                    child: Center(
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Quên mật khẩu?",
                          style: TextStyle(
                              color: Color.fromRGBO(196, 135, 198, 1)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1900),
                    child: MaterialButton(
                      onPressed: () {
                        _login();
                      },
                      color: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      height: 50,
                      child: const Center(
                        child: Text(
                          "Đăng Nhập",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeInUp(
                      duration: const Duration(milliseconds: 2000),
                      child: Center(
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterPage()),
                                );
                              },
                              child: const Text(
                                "Chưa có tài khoản? Đăng kí ngay",
                                style: TextStyle(
                                    color: Color.fromRGBO(49, 39, 79, .6)),
                              )))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Additional helper widget for text fields to reduce redundancy
class TextFieldContainer extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const TextFieldContainer({
    Key? key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Color.fromRGBO(196, 135, 198, .3)))),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade700)),
      ),
    );
  }
}
