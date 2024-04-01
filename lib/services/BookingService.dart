import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ManageBooking.dart';
import '../models/VehicleBooking.dart';
import 'ServiceConstants.dart';
import 'AuthService.dart';

class BookingService {
  static const String baseUrl = "${ServiceConstants.baseUrl}/bookings";

  static Future<List<Booking>?> getAllUserBookings(int userId) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final url = '$baseUrl/allUserBookings/$userId';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': ' $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      List<dynamic> bookingsData = jsonResponse['bookings'];
      List<Booking> bookings = bookingsData
          .map<Booking>((bookingJson) => Booking.fromJson(bookingJson))
          .toList();
      return bookings;
    } else {
      return null;
    }
  }

  static Future<bool> createBooking(Booking booking) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final url =
        '$baseUrl/create/'; // Ensure this endpoint matches your server configuration
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': ' $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'ngay_bat_dau': booking.startDate.toIso8601String(),
        'ngay_ket_thuc': booking.endDate.toIso8601String(),
        'dia_chi_nhan_xe': booking.pickupAddressId,
        'tong_tien_thue': booking.totalRental,
        'ma_xe': booking.carId,
        'ma_nguoi_dat_xe': booking.userId,
        'ma_chu_xe': booking.ownerId,
        'ghi_chu': booking.notes,
        'giam_gia': booking.discount,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to create booking');
    }
  }

  static Future<bool> confirmBooking(int bookingId) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final url =
        '$baseUrl/confirmBooking/$bookingId'; // Assuming this is the correct endpoint for confirming a booking
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': ' $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Assuming a 200 status code means the booking was successfully confirmed
      return true;
    } else {
      // Handle HTTP errors
      throw Exception('Failed to confirm booking');
    }
  }

  static Future<bool> completeBooking(int bookingId) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final url =
        '$baseUrl/completeBooking/$bookingId'; // Assuming this is the endpoint for completing a booking
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': ' $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Assuming a 200 status code means the booking was successfully completed
      return true;
    } else {
      // Handle HTTP errors
      throw Exception('Failed to complete booking');
    }
  }

  static Future<bool> cancelBooking(int bookingId) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final url =
        '$baseUrl/cancelBooking/$bookingId'; // Assuming this is the endpoint for canceling a booking
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': ' $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to cancel booking');
    }
  }

  static Future<List<ManageBooking>?> getManagedBookings(int ownerId) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final url = '$baseUrl/getManageBooking/$ownerId'; // Adjust URL as needed
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': ' $token', // Make sure the token is correctly prefixed with 'Bearer ' if needed
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Assuming the list of bookings is under a key in the JSON response
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse.containsKey('data')) { // Replace 'data' with the actual key used by your API
        final List<dynamic> bookingsData = jsonResponse['data'];
        List<ManageBooking> bookings = bookingsData.map((bookingJson) => ManageBooking.fromJson(bookingJson)).toList();
        return bookings;
      } else {
        print('The expected key was not found in the response.');
        return null;
      }
    } else {
      print('Failed to fetch managed bookings: ${response.body}');
      return null; // or throw an exception based on your error handling strategy
    }
  }

}
