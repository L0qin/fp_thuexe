import 'dart:convert';
import 'dart:io';
import 'package:fp_thuexe/services/AuthService.dart';
import 'package:http/http.dart' as http;
import 'ServiceConstants.dart';

class ImageService {
  static const String baseUrl = "${ServiceConstants.baseUrl}/images";

  static Future<String> getVehicleMainImageURLById(int id) async {
    final url = '$baseUrl/mainimage/$id';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final imageName = body["hinh"] ?? "";
      if (imageName.toString().isEmpty) {
        return "";
      }
      final imageURL = '$baseUrl/getimages/$imageName';
      return imageURL;
    } else {
      return "";
    }
  }

  static String getImageByName(String imageName) {
    final imageURL = '$baseUrl/getimages/$imageName';
    return imageURL;
  }

  static Future<List<String>> getAllVehicleImageURLsById(int id) async {
    final url = '$baseUrl/allimage/$id';
    final response = await http.get(
      Uri.parse(url),
    );
    if (response.statusCode == 200) {
      final List<dynamic> imagesData = json.decode(response.body);
      List<String> imageUrls = imagesData.map((imageData) {
        final imageName = imageData['hinh'];
        return imageName.isEmpty ? "" : '$baseUrl/getimages/$imageName';
      }).toList();
      return imageUrls;
    } else {
      throw Exception('Failed to load images');
    }
  }

  static Future<String> postImage(
      String loaiHinh, String maXe, File imageFile) async {
    final url = '$baseUrl';
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Set authorization token
    request.headers['Authorization'] = token;

    // Add fields to the request
    request.fields['loai_hinh'] = loaiHinh;
    request.fields['ma_xe'] = maXe;

    // Add image file to the request
    var imageStream = http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();
    var multipartFile = http.MultipartFile('image', imageStream, length,
        filename: imageFile.path.split('/').last);
    request.files.add(multipartFile);

    // Send the request
    var response = await request.send();

    // Check the response status code
    if (response.statusCode == 201) {
      final dynamic responseData =
          json.decode(await response.stream.bytesToString());
      final String imageUrl = '$baseUrl/getimages/${responseData["hinh"]}';
      return imageUrl;
    } else {
      throw Exception('Failed to post image');
    }
  }

  // Update an existing image
  static Future<void> updateImage(
      int id, Map<String, dynamic> imageData, String token) async {
    final url = '$baseUrl/$id';
    final response = await http.put(Uri.parse(url),
        headers: {'Authorization': token}, body: json.encode(imageData));
    if (response.statusCode != 200) {
      throw Exception('Failed to update image');
    }
  }

  // Delete an existing image
  static Future<void> deleteImage(int id, String token) async {
    final url = '$baseUrl/$id';
    final response =
        await http.delete(Uri.parse(url), headers: {'Authorization': token});
    if (response.statusCode != 200) {
      throw Exception('Failed to delete image');
    }
  }
}
