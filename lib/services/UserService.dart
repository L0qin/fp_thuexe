import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/Notification.dart';
import '../models/User.dart';
import 'AuthService.dart';
import 'ServiceConstants.dart';

class UserService {
  static const String baseUrl = "${ServiceConstants.baseUrl}/users";

  static Future<void> readAllBookingNotifications(int userId) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final url = '$baseUrl/readAllBookingNotifications/$userId';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Authorization': ' $token'},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['success']) {
        print(jsonData['message']); // Optionally handle messages from server
      } else {
        throw Exception(jsonData['message']);
      }
    } else {
      final jsonData = jsonDecode(response.body);
      throw Exception('Failed to mark all booking notifications as read: ${jsonData['message']}');
    }
  }

  static Future<int> getUserUnreadNotificationCount() async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final userId = await AuthService.getUserId();
    if (userId == null) {
      throw Exception('userId not found');
    }

    final url = '$baseUrl/getUserUnreadNotification/$userId';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': ' $token'},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      int newNotificationsCount = jsonData['newNotificationsCount'];
      return newNotificationsCount;
    } else {
      final jsonData = jsonDecode(response.body);
      throw Exception('Failed to load unread notification count: ${jsonData['message']}');
    }
  }

  static Future<void> deleteNotification(int notificationId) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final url =
        '$baseUrl/deleteNotification/$notificationId';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Authorization': ' $token'},
    );

    if (response.statusCode != 200) {
      final jsonData = jsonDecode(response.body);
      throw Exception(jsonData['message'] ?? 'Failed to delete notification');
    }
  }

  static Future<void> markNotificationAsRead(int notificationId) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final url =
        '$baseUrl/markNotificationAsRead/$notificationId';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Authorization': ' $token'},
    );

    if (response.statusCode != 200) {
      final jsonData = jsonDecode(response.body);
      throw Exception(
          jsonData['message'] ?? 'Failed to mark notification as read');
    }
  }

  static Future<int> getUserNewNotificationNumber(int userId) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final url = '$baseUrl/getUserNewNotificationNumber/$userId';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': ' $token'
      }, // Ensure proper formatting for the Authorization header
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      int newNotificationsCount = jsonData['newNotificationsCount'];
      return newNotificationsCount;
    } else {
      throw Exception('Failed to load new notification count');
    }
  }

  static Future<List<ThongBao>> getUserNotifications(int userId) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }
    final url = '$baseUrl/getUserNotification/$userId';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': ' $token'},
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      List<ThongBao> notifications =
          jsonData.map((data) => ThongBao.fromJson(data)).toList();
      return notifications;
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  // Method to retrieve user data by ID
  static Future<User?> getUserById(int userId) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final url = '$baseUrl/$userId';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': ' $token'},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      return User(
        jsonData['ma_nguoi_dung'] as int,
        // Assuming ma_nguoi_dung is always non-null and an int
        jsonData['ten_nguoi_dung'] as String,
        // Assuming ten_nguoi_dung is always non-null
        "",
        // Assuming mat_khau_hash is always non-null
        jsonData['ho_ten'] as String,
        // Assuming ho_ten is always non-null
        jsonData['hinh_dai_dien'] == null
            ? ''
            : '${ServiceConstants.baseUrl}/images/getimages/${jsonData['hinh_dai_dien']}',
        jsonData['ngay_dang_ky'] == null
            ? null
            : DateTime.parse(jsonData['ngay_dang_ky']),
        jsonData['so_dien_thoai'],
        // Assuming so_dien_thoai can be null
        jsonData[
            'dia_chi_nguoi_dung'], // Assuming dia_chi_nguoi_dung can be null
      );
    } else {
      throw Exception('Failed to load user data');
    }
  }

  static Future<bool> updateUserProfilePicture(
      int userId, File imageFile) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final url = '${ServiceConstants.baseUrl}/images/userimages';
    var request = http.MultipartRequest('POST', Uri.parse(url))
      ..headers['Authorization'] = ' $token';

    request.fields['ma_nguoi_dung'] = userId.toString();

    // Handle file upload
    var imageStream = http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();
    var multipartFile = http.MultipartFile(
      'image',
      imageStream,
      length,
      filename: imageFile.path.split('/').last,
    );
    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      print(
          'Failed to update profile picture with status code: ${response.statusCode}');
      return false;
    }
  }

  static Future<bool> registerUser({
    required String username,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String address,
  }) async {
    const url = '$baseUrl/register';
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

  // Method to update an existing user
  static Future<bool> updateUser(
      int userId, String fullName, String phoneNumber, String address) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final url = '$baseUrl/$userId';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': ' $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'address': address,
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
