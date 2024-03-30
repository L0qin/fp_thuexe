import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/VehicleBooking.dart';
import 'ServiceConstants.dart';
import 'AuthService.dart'; // Ensure AuthService provides a method to get a token

class BookingService {
  static const String baseUrl = "${ServiceConstants.baseUrl}/bookings";

  // Get a specific booking by ID
  static Future<dynamic> getBookingById(int bookingId) async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/$bookingId'),
      headers: {'Authorization': ' $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load booking');
    }
  }

  // Get all bookings for a specific user by ma_nguoi_dat_xe
  static Future<List<Booking?>?> getBookingsByUserId(int userId) async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/all/$userId'),
      headers: {'Authorization': ' $token'},
    );
    print("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      print((jsonList.map((json) => Booking.fromJson(json)).toList()).toString());
      return jsonList.map((json) => Booking.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  // Create a new booking entry
  static Future<void> createBooking(Map<String, dynamic> bookingData) async {
    final token = await AuthService.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: {
        'Authorization': ' $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(bookingData),
    );

    if (response.statusCode == 201) {
      print('Booking created successfully');
    } else {
      throw Exception('Failed to create booking');
    }
  }

  // Update an existing booking entry
  static Future<void> updateBooking(int bookingId, Map<String, dynamic> bookingData) async {
    final token = await AuthService.getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/$bookingId'),
      headers: {
        'Authorization': ' $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(bookingData),
    );

    if (response.statusCode == 200) {
      print('Booking updated successfully');
    } else {
      throw Exception('Failed to update booking');
    }
  }

  // Delete an existing booking entry
  static Future<void> deleteBooking(int bookingId) async {
    final token = await AuthService.getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/$bookingId'),
      headers: {'Authorization': ' $token'},
    );

    if (response.statusCode == 200) {
      print('Booking deleted successfully');
    } else {
      throw Exception('Failed to delete booking');
    }
  }

  // Method to close a booking
  static Future<void> closeBooking(int bookingId, int vehicleId) async {
    final token = await AuthService.getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/close/$bookingId'),
      headers: {
        'Authorization': ' $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'ma_xe': vehicleId}),
    );

    if (response.statusCode == 200) {
      print('Booking closed successfully');
    } else {
      throw Exception('Failed to close booking');
    }
  }
}
