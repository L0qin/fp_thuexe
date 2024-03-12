import 'dart:convert';
import 'package:fp_thuexe/services/ServiceConstants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = ServiceConstants.baseUrl;

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
        await _saveToken(token);
        return token;
      } else {
        return null;
      }
    } catch (e) {
      print('Error while logging in: $e');
      throw 'Network error: $e';
    }
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

  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
