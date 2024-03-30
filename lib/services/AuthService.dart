import 'dart:convert';
import 'package:fp_thuexe/models/User.dart';
import 'package:fp_thuexe/services/ServiceConstants.dart';
import 'package:fp_thuexe/services/UserService.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "${ServiceConstants.baseUrl}/users";

  static Future<String?> login(String username, String password) async {
    final url = '$baseUrl/login';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer 1',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['token'];
        final userId = jsonDecode(response.body)['userId'];
        await _saveInfo(token, userId.toString());
        final User? user = await UserService.getUserById(userId);

        if (user != null) {
          _saveUser(user);
          return token;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print('Error while logging in: $e');
      throw 'Network error: $e';
    }
  }


  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
    prefs.remove('user');
    prefs.remove('token');
  }

  static Future<bool> register(String username, String password,
      String fullName, String phoneNumber, String address) async {
    final url = '$baseUrl/register';
    try {
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
        // User registered successfully
        return true;
      } else if (response.statusCode == 409) {
        // Username already exists
        return false;
      } else {
        // Handle other error cases
        throw 'HTTP ${response.statusCode}: ${response.reasonPhrase}';
      }
    } catch (e) {
      print('Error while registering: $e');
      throw 'Network error: $e';
    }
  }

  static Future<void> _saveInfo(String token, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('userId', userId);

  }
  static Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', User.toJsonString(user));
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      return null; // No token found
    }

    // Decode the token to get its payload (assuming it's a JWT)
    final parts = token.split('.');
    if (parts.length != 3) {
      // Invalid token format
      prefs.remove('token'); // Remove invalid token
      return null;
    }

    // Extract the payload from the token
    final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));

    // Check if the token is expired
    final int expiry = payload['exp'];
    final int now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (expiry != null && expiry <= now) {
      // Token has expired
      prefs.remove('token'); // Remove expired token
      return null;
    }

    return token;
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    return int.parse(userId ?? "-1");
  }

  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');

    return User.fromJsonToUser(userJson!);
  }
}
