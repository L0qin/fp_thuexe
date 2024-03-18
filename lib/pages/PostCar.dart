import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fp_thuexe/services/AuthService.dart';
import 'package:image_picker/image_picker.dart';

import '../models/User.dart';
import '../models/Vehicle.dart';
import '../services/ImageService.dart';
import '../services/VehicleService.dart';

class PostCar extends StatefulWidget {
  const PostCar({super.key});

  @override
  State<PostCar> createState() => _PostTheCarState();
}

class _PostTheCarState extends State<PostCar> {
  TextEditingController _controllerUserName = TextEditingController();
  TextEditingController _controllerPhone = TextEditingController();
  TextEditingController _controllerCarTitle = TextEditingController();
  TextEditingController _controllerModel = TextEditingController();
  TextEditingController _controllerDescription = TextEditingController();
  TextEditingController _controllerRentalPrice = TextEditingController();
  TextEditingController _controllerSeating = TextEditingController();
  TextEditingController _controllerAddress = TextEditingController();
  String _selectedCarBrand = '';
  Vehicle? _vehicle;
  late Timer _timer;
  late User _user;

  File? _mainImage;
  List<File> _otherImages = [];

  final _picker = ImagePicker();

  Future<void> postImages(String maXe) async {
    try {
      // Post main image
      if (_mainImage != null) {
        await ImageService.postImage('1', maXe, _mainImage!);
      }

      // Post other images
      for (var imageFile in _otherImages) {
        await ImageService.postImage('0', maXe, imageFile);
      }

      print('Images posted successfully');
    } catch (e) {
      print('Error posting images: $e');
      // Handle errors
    }
  }

  void _submitForm() async {
    _vehicle = Vehicle(
      -1,
      _controllerCarTitle.text,
      0,
      _controllerModel.text,
      _selectedCarBrand,
      _controllerAddress.text,
      _controllerDescription.text,
      double.tryParse(_controllerRentalPrice.text) ?? 0.0,
      int.tryParse(_controllerSeating.text) ?? 0,
      _user.userId,
      1,
    );

    // Ensure default values are set if fields are empty
    if (_vehicle!.carName.isEmpty) _vehicle!.carName = "";
    if (_vehicle!.model.isEmpty) _vehicle!.model = "";
    if (_vehicle!.manufacturer.isEmpty) _vehicle!.manufacturer = "";
    if (_vehicle!.address.isEmpty) _vehicle!.address = "";
    if (_vehicle!.description.isEmpty) _vehicle!.description = "";
    if (_vehicle!.carId == null) _vehicle!.carId = -1;
    if (_vehicle!.status == null) _vehicle!.status = -1;
    if (_vehicle!.ownerName == null) _vehicle!.ownerName = -1;
    if (_vehicle!.categoryId == null) _vehicle!.categoryId = -1;

    // Post the vehicle to the server
    try {
      final insertId = await VehicleService.postVehicle(_vehicle!);
      if (insertId != null) {
        // Post images using the insert ID
        await postImages(insertId.toString());

        // Show success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Vehicle posted successfully with ID: $insertId'),
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
      } else {
        // Show failure dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to post vehicle'),
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
      print('Error: $e');
      // Handle errors
    }
  }


  Future<void> getImage(bool isMainImage) async {
    final pickedFiles = await _picker
        .getMultiImage(); // Use getMultiImage to select multiple images

    if (pickedFiles != null) {
      setState(() {
        for (var pickedFile in pickedFiles) {
          File imageFile = File(pickedFile.path);
          if (isMainImage) {
            _mainImage = imageFile;
          } else {
            _otherImages.add(imageFile);
          }
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      AuthService.getUser().then((user) {
        if (user != null) {
          setState(() {
            _user = user;
            _controllerUserName.text = _user.fullName;
            _controllerPhone.text = _user.phoneNumber;
          });
          _stopTimer();
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
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
        elevation: 0.0, // Remove default shadow for a cleaner look
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: SingleChildScrollView(
        // Enable scrolling for long content
        child: Column(
          children: [
            SizedBox(height: 10.0),
            _buildCarDetailsCard(),
            SizedBox(height: 10.0),
            _buildRentingInfoCard(),
            SizedBox(height: 10.0),
            _buildImageUploadCard(),
            SizedBox(height: 10.0),
            _buildOwnerDetailsCard(),
            SizedBox(height: 10.0),
            _buildSubmitButton(),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  Widget _buildCarDetailsCard() {
    return Card(
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
              controller: _controllerCarTitle,
              decoration: const InputDecoration(
                labelText: "Tiêu đề",
              ),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: _controllerModel,
              decoration: InputDecoration(
                labelText: "Model",
              ),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: _controllerDescription,
              maxLines: 5, // Allows for multiple lines
              decoration: InputDecoration(
                labelText: "Mô tả",
                alignLabelWithHint: true,
                // Align label with the top of the input field
                hintText: "Nhập mô tả",
                // Optional hint text
                border: OutlineInputBorder(), // Optional border
              ),
            ),
            SizedBox(height: 10.0),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Chọn hãng xe',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              value:
                  _selectedCarBrand.isEmpty ? 'Hãng khác' : _selectedCarBrand,
              items: [
                'Hãng khác', // Add the default item
                'Honda',
                'Toyota',
                'Ford',
                // Add other items as needed
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCarBrand = value!;
                });
              },
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: _controllerSeating,
              decoration: InputDecoration(
                labelText: "Số chỗ ngồi",
              ),
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  Widget _buildRentingInfoCard() {
    return Container(
      width: double.infinity,
      child: Card(
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
                "Thông tin thuê xe", // Car details
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _controllerRentalPrice,
                keyboardType: TextInputType.number,
                // Accepts only numeric input
                decoration:
                    InputDecoration(labelText: "Giá thuê", suffix: Text("vnd")),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _controllerAddress,
                keyboardType: TextInputType.text,
                // Accepts text input
                decoration: InputDecoration(labelText: "Địa chỉ xe"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploadCard() {
    return Container(
      width: double.infinity,
      child: Card(
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
                "Hình ảnh xe",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                "Ảnh chính",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildMainImageUpload(_mainImage, true),
              SizedBox(height: 10.0),
              Text(
                "Ảnh khác",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildOtherImageUpload(_otherImages),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOwnerDetailsCard() {
    return Card(
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
              controller: _controllerUserName,
              decoration: InputDecoration(
                labelText: "Họ và tên", // Full name
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _controllerPhone,
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
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      margin: EdgeInsets.all(12),
      child: MaterialButton(
        onPressed: () {
          _submitForm();
        },
        height: 50,
        minWidth: double.infinity,
        color: Colors.teal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          "Đăng Xe",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
    );
  }

  Widget _buildMainImageUpload(File? image, bool isMainImage) {
    void removeMainImage() {
      setState(() {
        _mainImage = null; // Clear the _mainImage variable
      });
    }

    return GestureDetector(
      onTap: () {
        getImage(true);
      },
      child: image != null
          ? Stack(
              children: [
                Image.file(
                  image,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      removeMainImage(); // Call the function to remove the main image
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : SizedBox(
              width: 150,
              height: 150,
              child: Container(
                color: Colors.grey[300],
                child: Icon(
                  Icons.add_a_photo,
                  size: 75,
                  color: Colors.grey[600],
                ),
              ),
            ),
    );
  }

  Widget _buildOtherImageUpload(List<File> images) {
    return GestureDetector(
      onTap: () {
        getImage(false);
      },
      child: SizedBox(
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                ...images.asMap().entries.map((entry) {
                  int index = entry.key;
                  File image = entry.value;
                  return index < images.length - 1
                      ? Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(
                                image,
                                width: MediaQuery.of(context).size.width * 0.2,
                                height: MediaQuery.of(context).size.width * 0.2,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  iconSize: 16,
                                  padding: EdgeInsets.zero,
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      images.removeAt(index);
                                    });
                                  },
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        )
                      : SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                          child: Container(
                            color: Colors.grey[300],
                            child: Icon(Icons.add_a_photo,
                                size: 50, color: Colors.grey[600]),
                          ),
                        );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
