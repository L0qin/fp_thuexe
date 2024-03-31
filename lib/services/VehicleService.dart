import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Review.dart';
import '../models/Vehicle.dart';
import 'AuthService.dart';
import 'ServiceConstants.dart';

class VehicleService {
  static const String baseUrl = "${ServiceConstants.baseUrl}/vehicles";

  static Future<List<Review>> getAllVehicleReviews(int maXe) async {
    final url = '$baseUrl/getAllVehicleReviews/$maXe';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((json) => Review.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Reviews');
    }
  }

  static Future<void> addReview(
      int maXe, int maNguoiDung, int soSao, String binhLuan) async {
    final url = '$baseUrl/addReview/';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'ma_xe': maXe,
        'ma_nguoi_dung': maNguoiDung,
        'so_sao': soSao,
        'binh_luan': binhLuan,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add Review');
    }
  }

  static Future<Vehicle?> getVehicleById(int vehicleId) async {
    final url = '$baseUrl/$vehicleId';
    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Vehicle(
        jsonData['ma_xe'],
        jsonData['ten_xe'],
        jsonData['trang_thai'],
        jsonData['model'],
        jsonData['hang_sx'],
        jsonData['dia_chi'],
        jsonData['mo_ta'],
        jsonData['gia_thue']?.toDouble() ?? 0.0,
        jsonData['so_cho'],
        jsonData['chu_so_huu'],
        jsonData['ma_loai_xe'],
      );
    } else {
      throw Exception('Failed to load vehicle data');
    }
  }

  // Method to retrieve all vehicles
  static Future<List<Vehicle>> getAllVehicles() async {
    final url = '$baseUrl';
    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((vehicleJson) {
        return Vehicle(
          vehicleJson['ma_xe'],
          vehicleJson['ten_xe'],
          vehicleJson['trang_thai'],
          vehicleJson['model'],
          vehicleJson['hang_sx'],
          vehicleJson['dia_chi'],
          vehicleJson['mo_ta'],
          vehicleJson['gia_thue']?.toDouble() ?? 0.0,
          vehicleJson['so_cho'],
          vehicleJson['chu_so_huu'],
          vehicleJson['ma_loai_xe'],
        );
      }).toList();
    } else {
      throw Exception('Failed to load vehicles');
    }
  }

  // Method to search vehicles based on a keyword
  static Future<List<Vehicle>> searchVehicles(String keyword) async {
    final url = '$baseUrl/search/$keyword';
    final response = await http.get(
      Uri.parse(url),
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((vehicleJson) {
        return Vehicle(
          vehicleJson['ma_xe'],
          vehicleJson['ten_xe'],
          vehicleJson['trang_thai'],
          vehicleJson['model'],
          vehicleJson['hang_sx'],
          vehicleJson['dia_chi'],
          vehicleJson['mo_ta'],
          vehicleJson['gia_thue']?.toDouble() ?? 0.0,
          vehicleJson['so_cho'],
          vehicleJson['chu_so_huu'],
          vehicleJson['ma_loai_xe'],
        );
      }).toList();
    } else {
      throw Exception('Failed to search vehicles');
    }
  }

  // Method to post a new vehicle
  static Future<int?> postVehicle(Vehicle vehicle) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final url = '$baseUrl';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'ten_xe': vehicle.carName,
        'trang_thai': vehicle.status,
        'model': vehicle.model,
        'hang_sx': vehicle.manufacturer,
        'dia_chi': vehicle.address,
        'mo_ta': vehicle.description,
        'gia_thue': vehicle.rentalPrice,
        'so_cho': vehicle.seating,
        'chu_so_huu': vehicle.ownerId,
        'ma_loai_xe': vehicle.categoryId,
      }),
    );

    if (response.statusCode == 201) {
      final dynamic responseData = json.decode(response.body);
      final int? insertId =
          responseData['id']; // Assuming 'id' is the key for insertId
      print('Vehicle posted successfully with ID: $insertId');
      return insertId;
    } else {
      print('Failed to post vehicle');
      return null;
    }
  }

  static Future<bool> checkBookable(int userId) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final url =
        '$baseUrl/checkBookable?ma_nguoi_dat_xe=$userId'; // Adjust the URL based on your actual endpoint
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token', // Ensure proper formatting for the Authorization header
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return responseBody['isBookable'];
    } else {
      // Consider handling different status codes and errors more specifically
      throw Exception('Failed to check if user can book');
    }
  }

}
