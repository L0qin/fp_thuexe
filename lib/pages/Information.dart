import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fp_thuexe/model/UserCar.dart';

import '../shared/widgets/BottomBar.dart';

class Information extends StatefulWidget {
  const Information({super.key});

  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information> {
TextEditingController _UserNameController=TextEditingController();
TextEditingController _DaddressController=TextEditingController();
TextEditingController _phoneNumberController=TextEditingController();
TextEditingController _profilePictureController=TextEditingController();
List<User> _user=[];

  @override
  void initState() {
    super.initState();
    fectData();
  }
Future<void>fectData()async{
await Future.delayed(Duration(seconds: 2));//ảo
List<User> fecthUser=[
  User(
    1,
    'api_username_1',
    'api_password_hash_1',
    'API User 1',
    'assets/images/users/cv.png',
    DateTime.now(),
    9876543210,
    'API Address 1',
  ),
  User(
    2,
    'api_username_2',
    'api_password_hash_2',
    'API User 2',
    'assets/images/users/cv.png',
    DateTime.now(),
    9876543211,
    'API Address 2',
  ),
];
setState(() {
  _user=fecthUser;
});
if (_user.isNotEmpty) {
  loadFetchedData(_user[0]);
}

}
void loadFetchedData(User user) {
  _UserNameController.text=user.username;
  _DaddressController.text = user.address;
  _phoneNumberController.text = user.phoneNumber?.toString() ?? '';
  _profilePictureController.text = user.profilePicture;
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
                      //backgroundImage:
                           //AssetImage('assets/images/users/cv.png'),
                      backgroundImage: AssetImage(_profilePictureController.text),
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
                    'Name: ${_UserNameController.text}',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Email:  ${_DaddressController.text}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Phone: ${_phoneNumberController.text}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      Text(
                        "Tài khoản",
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
