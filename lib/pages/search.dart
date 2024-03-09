import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _nameSearch = TextEditingController();


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thuê Xe'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(
              child: TextField(
                controller: _nameSearch,
                decoration: InputDecoration(hintText: "My car is named"),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String carName = _nameSearch.text;
                print('Car Name: $carName');
              },
              child: Text('Tìm Xe'),
            ),
            SizedBox(height: 16.0),
            Container(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 60,
                        height: 70,
                        color: Colors.cyan,
                      ),
                      SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Kia",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.blue),
                            ),
                            Text(
                              "Phạm Trường",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.blue),
                            ),
                            SizedBox(),
                            Text(
                              "Cao Lỗ",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.blue),
                            )
                          ],
                        ),
                      ),
                      const Text(
                        "250VNĐ/Ngày",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
            // Add more items to the ListView as needed
          ],
        ),
      ),
    );
  }
}

