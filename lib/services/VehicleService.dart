import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Vehicle.dart';
import 'AuthService.dart';
import 'ServiceConstants.dart';

class VehicleService {
  static const String baseUrl = ServiceConstants.baseUrl;

  static Future<Vehicle?> getVehicleById(int vehicleId) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final url = '$baseUrl/vehicles/$vehicleId';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': token},
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
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final url = '$baseUrl/vehicles';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': token},
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
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final url = '$baseUrl/vehicles/search/$keyword';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': token},
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
}
