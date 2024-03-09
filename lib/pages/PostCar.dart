import 'package:flutter/material.dart';

class PostTheCar extends StatefulWidget {
  const PostTheCar({super.key});

  @override
  State<PostTheCar> createState() => _PostTheCarState();
}

class _PostTheCarState extends State<PostTheCar> {
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
    return Container(
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
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text('Tên Xe',
                          style: TextStyle(fontSize: 14, color: Colors.green)),
                    ),
                    Expanded(
                      child: Text("Nguyễn Văn A",
                          style: TextStyle(fontSize: 15, color: Colors.black)),
                    ),
                  ],
                ),
                SizedBox(height: 8), // Add some vertical spacing
                Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text('Địa chỉ',
                          style: TextStyle(fontSize: 14, color: Colors.green)),
                    ),
                    Expanded(
                      child: Text("180 Cao Lỗ",
                          style: TextStyle(fontSize: 15, color: Colors.black)),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text('Cho thuê xe',
                          style: TextStyle(fontSize: 14, color: Colors.green)),
                    ),
                    Expanded(
                      child: Column(children: [
                        Row(
                          children: [
                            Checkbox(
                              value: true,
                              // Set your boolean variable for the first checkbox here,
                              onChanged: (value) {},
                            ),
                            Text('Ngày',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black)),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: true,
                              // Set your boolean variable for the first checkbox here,
                              onChanged: (value) {},
                            ),
                            Text('Tuần',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black)),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: true,
                              // Set your boolean variable for the first checkbox here,
                              onChanged: (value) {},
                            ),
                            Text('Tháng',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black)),
                          ],
                        ),
                      ]),
                    ),
                  ],
                ),
                SizedBox(height: 8), // Add some vertical spacing
                Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text('Cho Thuê tối đa',
                          style: TextStyle(fontSize: 14, color: Colors.green)),
                    ),
                    Expanded(
                      child: TextField(
                          controller: _soNgay,
                          decoration: InputDecoration(hintText: "Ngày"),
                          style: TextStyle(fontSize: 15, color: Colors.black)),
                    ),
                    Text("Ngày"),
                  ],
                ),
                Divider(),
                SizedBox(height: 8), // Add some vertical spacing
                Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text('Giá Thuê',
                          style: TextStyle(fontSize: 14, color: Colors.green)),
                    ),
                    Expanded(
                      child: TextField(
                          controller: _soNgay,
                          decoration: InputDecoration(hintText: "VNĐ"),
                          style: TextStyle(fontSize: 10, color: Colors.black)),
                    ),
                    Text("Ngày"),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text('Upload File',
                          style: TextStyle(fontSize: 14, color: Colors.green)),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Show file picker dialog or implement your file uploading logic here
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('File Picker'),
                                content: Text('Implement your file picker logic here'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Close'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('Choose File'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
