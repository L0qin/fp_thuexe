
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

  // void _pickImage() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.image,
  //     allowMultiple: false,
  //   );
  //
  //   if (result != null) {
  //     PlatformFile file = result.files.first;
  //     setState(() {
  //       _profilePicture = File(file.path!);
  //       _imagePicked = true;
  //     });
  //   } else {
  //     // Người dùng không chọn ảnh
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Đăng ký xe", // Using "Đăng ký xe" for clarity
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        elevation: 0.0, // Remove default shadow for a cleaner look
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView( // Enable scrolling for long content
          child: Column(
            children: [
              SizedBox(height: 20.0), // Add some top padding
              // Container(
              //   margin: EdgeInsets.all(10),
              //   child: _imageFile == null
              //       ? OutlinedButton.icon(
              //     style: OutlinedButton.styleFrom(
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10.0),
              //       ),
              //     ),
              //     onPressed: _pickImage,
              //     icon: Icon(Icons.add_a_photo),
              //     label: Text("Tải lên ảnh xe"),
              //   )
              //       : Stack(
              //     children: [
              //       Image.file(File(_imageFile.path), width: 150, height: 150, fit: BoxFit.cover),
              //       Positioned.fill(
              //         child: Align(
              //           alignment: Alignment.center,
              //           child: CircularProgressIndicator(),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Card for car details
              Card(
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // Left-align labels
                    children: [
                      Text(
                        "Thông tin xe", // Car details
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Biển số xe", // License plate
                        ),
                      ),
                      SizedBox(height: 10.0),
                      DropdownButtonFormField<String>(
                        // value: selectedCarBrand,
                        decoration: InputDecoration(
                          labelText: 'Chọn hãng xe',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        items: [
                          'Honda',
                          'Toyota',
                          'Ford',
                          // Thêm các hãng xe khác nếu cần
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            // selectedCarBrand = value!;
                          });
                        },
                      ),

                      SizedBox(height: 10.0),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Model",
                        ),
                      ),
                      SizedBox(height: 10.0),
                      DropdownButtonFormField<DateTime>(
                        // value: selectedDateTime,
                        decoration: InputDecoration(
                          labelText: 'Chọn ngày/giờ',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        items: List.generate(
                          7,
                              (index) {
                            final date = DateTime.now().add(Duration(days: index));
                            return DropdownMenuItem(
                              value: date,
                              child: Text(date.toString()),
                            );
                          },
                        ),
                        onChanged: (value) {
                          setState(() {
                            // selectedDateTime = value!;
                          });
                        },
                      ),

                    ],
                  ),
                ),
              ),


              SizedBox(height: 20.0), // Add some spacing

              // Card for owner details
              Card(
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Thông tin chủ xe", // Owner details
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Họ và tên", // Full name
                        ),
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Số điện thoại",
                          prefixIcon: Icon(
                            Icons.flag,
                            size: 24.0,
                          ),
                          prefixText: "+84 ",
                        ),
                      ),

                      SizedBox(height: 10.0),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Email",
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.0), // Add some spacing

              // Submit button
              Container(
                margin: EdgeInsets.all(12),
                child: MaterialButton(
                  onPressed: () {},
                  height: 50,
                  minWidth: double.infinity,
                  color: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    "Đăng ký xe",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),

              SizedBox(height: 20.0), // Add some bottom padding
            ],
          ),
        ),
      ),
    );
  }
}

