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
        '$baseUrl/images/getimages/' + jsonData['hinh_dai_dien'],
        DateTime.parse(jsonData['ngay_dang_ky']),
        jsonData['so_dien_thoai'],
        jsonData['dia_chi_nguoi_dung'],
      );
    } else {
      throw Exception('Failed to load user data');
    }
  }

  static Future<bool> registerUser({
    required String username,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String address,
  }) async {
    final url = '$baseUrl/register';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'address': address,
      }),
    );

    if (response.statusCode == 201) {
      print('User registered successfully');
      return true;
    } else if (response.statusCode == 400) {
      final responseData = jsonDecode(response.body);
      throw Exception(responseData['message']);
    } else if (response.statusCode == 409) {
      throw Exception('Username already exists');
    } else {
      throw Exception('Failed to register user');
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

  // Method to update an existing user
  static Future<bool> updateUser(
      int userId, String fullName, String phoneNumber, String address) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final url = '$baseUrl/users/$userId';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': ' $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'ho_ten': fullName,
        'so_dien_thoai': phoneNumber,
        'dia_chi_nguoi_dung': address,
      }),
    );

    if (response.statusCode == 200) {
      print('User updated successfully');
      return true;
    } else {
      print('Failed to update user');
      return false;
    }
  }
}
