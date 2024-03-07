import 'package:flutter/material.dart';

class DetailCar extends StatefulWidget {
  const DetailCar({super.key});

  @override
  State<DetailCar> createState() => _DetailCarState();
}

class _DetailCarState extends State<DetailCar>
    with SingleTickerProviderStateMixin {
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
      body: Container(
        child: Column(
          children: [
            Card(
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                )),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("Kia Moring",
                          style: TextStyle(fontSize: 14, color: Colors.green)),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
