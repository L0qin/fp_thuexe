import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/User.dart';
import 'AuthService.dart';
import 'ServiceConstants.dart';

class UserService {
  static const String baseUrl = ServiceConstants.baseUrl;

  // Method to retrieve user data by ID
  static Future<User?> getUserById(int userId) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final url = '$baseUrl/users/$userId';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': ' $token'},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return User(
        jsonData['ma_nguoi_dung'],
        jsonData['ten_nguoi_dung'],
        jsonData['mat_khau_hash'],
        jsonData['ho_ten'],
        '$baseUrl/images/getimages/hinh1.jpg',
        DateTime.parse(jsonData['ngay_dang_ky']),
        jsonData['so_dien_thoai'],
        jsonData['dia_chi_nguoi_dung'],
      );
    } else {
      throw Exception('Failed to load user data');
    }
  }

  // Method to retrieve all users
  static Future<List<User>> getAllUsers() async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final url = '$baseUrl/users';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': token},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((userJson) {
        return User(
          userJson['ma_nguoi_dung'],
          userJson['ten_nguoi_dung'],
          userJson['mat_khau_hash'],
          userJson['ho_ten'],
          userJson['hinh_dai_dien'],
          DateTime.parse(userJson['ngay_dang_ky']),
          userJson['so_dien_thoai'],
          userJson['dia_chi_nguoi_dung'],
        );
      }).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
