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
                      SizedBox(
                        width: 110,
                        child: Text('Hãng Xe',
                            style: TextStyle(fontSize: 25, color: Colors.green)),
                      ),
                      Expanded(
                        child: Text("Kia Morning",
                            style: TextStyle(fontSize: 20, color: Colors.black)),
                      ),
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
