import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../shared/widgets/BottomBar.dart';

class Information extends StatefulWidget {
  const Information({super.key});

  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          children: [
            Card(
              // padding: const EdgeInsets.all(8.0),
              elevation: 10.0,
              margin: EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Add your logic for handling the tap on the CircleAvatar
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('File Picker'),
                            content:
                                Text('Implement your file picker logic here'),
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
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          AssetImage('assets/images/icons/user.png'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Show a dialog or navigate to another screen for editing personal information
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Chỉnh sửa trang cá nhân'),
                            content: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Add your logic for handling the tap on the CircleAvatar
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('File Picker'),
                                          content: Text(
                                              'Implement your file picker logic here'),
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
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: AssetImage(
                                        'assets/images/icons/user.png'),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                // Add form fields or widgets for editing information
                                TextField(
                                  // controller: ,
                                  decoration: InputDecoration(
                                      hintText: "name",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  // Add appropriate properties for editing name
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextField(
                                  // controller: ,
                                  decoration: InputDecoration(
                                      hintText: "Email",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextField(
                                  // controller: ,
                                  decoration: InputDecoration(
                                    hintText: "Phone",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Add logic for saving the edited information
                                  Navigator.of(context).pop();
                                },
                                child: Text('Save'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Chỉnh Sửa'),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Name: Kim Trường',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Email: ABC@example.com',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Phone: +1 555-1234',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      Text(
                        "Tài khoảng",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.normal),
                      )
                    ],
                  ),
                  Divider(),
                  InkWell(
                    onTap: () {
                      // Thêm logic khi hàng được nhấn
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.history,
                          // Thay bằng biểu tượng (icon) mà bạn muốn sử dụng
                          size: 30,
                          color: Colors.blue, // Màu của biểu tượng (icon)
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Đặt xe"),
                        Spacer(),
                        // Để tạo khoảng trống giữa text và hình ảnh
                        SizedBox(width: 8),
                        Text("Chuyến đi và lịch sử"),
                        // Khoảng trống giữa hình ảnh và nút
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            // Thêm logic khi nút được nhấn
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Divider(),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.payment,
                          // Thay bằng biểu tượng (icon) mà bạn muốn sử dụng
                          size: 30,
                          color: Colors.blue, // Màu của biểu tượng (icon)
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Phương thức thanh toán"),
                        Spacer(), // Để tạo khoảng trống giữa text và hình ảnh
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            // Thêm logic khi nút được nhấn
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Divider(),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.help,
                          // Thay bằng biểu tượng (icon) mà bạn muốn sử dụng
                          size: 30,
                          color: Colors.blue, // Màu của biểu tượng (icon)
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Trợ giúp & yêu cầu hỗ trợ"),
                        Spacer(), // Để tạo khoảng trống giữa text và hình ảnh
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            // Thêm logic khi nút được nhấn
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Divider(),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.language,
                          // Thay bằng biểu tượng (icon) mà bạn muốn sử dụng
                          size: 30,
                          color: Colors.blue, // Màu của biểu tượng (icon)
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Thay đổi ngôn ngữ"),
                        Spacer(), // Để tạo khoảng trống giữa text và hình ảnh
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            // Thêm logic khi nút được nhấn
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Divider(),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.notifications,
                          // Thay bằng biểu tượng (icon) mà bạn muốn sử dụng
                          size: 30,
                          color: Colors.blue, // Màu của biểu tượng (icon)
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Thông báo"),
                        Spacer(), // Để tạo khoảng trống giữa text và hình ảnh
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            // Thêm logic khi nút được nhấn
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Divider(),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.settings,
                          // Thay bằng biểu tượng (icon) mà bạn muốn sử dụng
                          size: 30,
                          color: Colors.blue, // Màu của biểu tượng (icon)
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Quản lý Tài Khoản"),
                        Spacer(), // Để tạo khoảng trống giữa text và hình ảnh
                        SizedBox(width: 8), // Khoảng trống giữa hình ảnh và nút
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            // Thêm logic khi nút được nhấn
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Divider(),
                  Row(
                    children: [
                      Text(
                        "Thông tin chung",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.normal),
                      )
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Divider(),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.receipt,
                          // Thay bằng biểu tượng (icon) mà bạn muốn sử dụng
                          size: 30,
                          color: Colors.blue, // Màu của biểu tượng (icon)
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Quy chế"),
                        Spacer(), // Để tạo khoảng trống giữa text và hình ảnh
                        SizedBox(width: 8), // Khoảng trống giữa hình ảnh và nút
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            // Thêm logic khi nút được nhấn
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Divider(),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.security,
                          // Thay bằng biểu tượng (icon) mà bạn muốn sử dụng
                          size: 30,
                          color: Colors.blue, // Màu của biểu tượng (icon)
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Bảo mật & đều khoảng"),
                        Spacer(),
                        // Để tạo khoảng trống giữa text và hình ảnh
                        SizedBox(width: 8),
                        Text(
                          "đông ý",
                          style: TextStyle(color: Colors.green),
                        ),
                        // Khoảng trống giữa hình ảnh và nút
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            // Thêm logic khi nút được nhấn
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Divider(),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          // Thay bằng biểu tượng (icon) mà bạn muốn sử dụng
                          size: 30,
                          color: Colors.blue, // Màu của biểu tượng (icon)
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Đáng gia ứng dụng"),
                        Spacer(),
                        // Để tạo khoảng trống giữa text và hình ảnh
                        SizedBox(width: 8),
                        Text(
                          "",
                          style: TextStyle(color: Colors.green),
                        ),
                        // Khoảng trống giữa hình ảnh và nút
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            // Thêm logic khi nút được nhấn
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
