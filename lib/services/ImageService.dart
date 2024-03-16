import 'dart:convert';
import 'package:fp_thuexe/services/AuthService.dart';
import 'package:http/http.dart' as http;
import 'ServiceConstants.dart';

class ImageService {
  static const String baseUrl = ServiceConstants.baseUrl;

  static Future<String> getVehicleImageURLById(int id) async {
    final token = await AuthService.getToken();
    final url = '$baseUrl/images/$id';
    final response = await http
        .get(Uri.parse(url), headers: {'Authorization': token.toString()});
    if (response.statusCode == 200) {
      final imageName = json.decode(response.body)["hinh"];
      if (imageName.toString().isEmpty) {
        return "";
      }
      final imageURL = '$baseUrl/images/getimages/$imageName';
      return imageURL;
    } else {
      throw Exception('Failed to load image');
    }
  }

  static Future<List<String>> getAllVehicleImageURLsById(int id) async {
    final token = await AuthService.getToken();
    final url = '$baseUrl/images/allimage/$id';
    final response = await http.get(Uri.parse(url), headers: {'Authorization': token.toString()});
    if (response.statusCode == 200) {
      final List<dynamic> imagesData = json.decode(response.body);
      List<String> imageUrls = imagesData.map((imageData) {
        final imageName = imageData['hinh'];
        return imageName.isEmpty ? "" : '$baseUrl/images/getimages/$imageName';
      }).toList();
      return imageUrls;
    } else {
      throw Exception('Failed to load images');
    }
  }

  // Create a new image
  static Future<String> createImage(
      Map<String, dynamic> imageData, String token) async {
    const url = '$baseUrl/images';
    final response = await http.post(Uri.parse(url),
        headers: {'Authorization': token}, body: json.encode(imageData));
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create image');
    }
  }

  // Update an existing image
  static Future<void> updateImage(
      int id, Map<String, dynamic> imageData, String token) async {
    final url = '$baseUrl/images/$id';
    final response = await http.put(Uri.parse(url),
        headers: {'Authorization': token}, body: json.encode(imageData));
    if (response.statusCode != 200) {
      throw Exception('Failed to update image');
    }
  }

  // Delete an existing image
  static Future<void> deleteImage(int id, String token) async {
    final url = '$baseUrl/images/$id';
    final response =
        await http.delete(Uri.parse(url), headers: {'Authorization': token});
    if (response.statusCode != 200) {
      throw Exception('Failed to delete image');
    }
  }
}
