import 'package:flutter/material.dart';

class PostCar extends StatefulWidget {
  const PostCar({super.key});

  @override
  State<PostCar> createState() => _PostTheCarState();
}

class _PostTheCarState extends State<PostCar> {
  TextEditingController _soNgay = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // _controller.dispose();
    // super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Đăng xe",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,

      ),
      body: Container(
          child: Column(
        children: [
          Card(
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(12),
            child: MaterialButton(
              onPressed: () {},
              height: 50,
              minWidth: double.infinity,
              color: Colors.teal,
              child: Text(
                "Đăng xe",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          )
        ],
      )),
    );
  }
}
