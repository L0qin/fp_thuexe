import 'dart:convert';
import 'package:http/http.dart' as http;

import 'ServiceConstants.dart';

class APIService {
  final String baseUrl =ServiceConstants.baseUrl;

  Future<List<Map<String, dynamic>>?> getAllDatXe() async {
    final url = '$baseUrl/datxe';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        return null;
      }
    } catch (e) {
      print('Error while getting all datxe: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getDatXeById(String id) async {
    final url = '$baseUrl/datxe/$id';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Error while getting datxe by ID: $e');
      return null;
    }
  }

  Future<bool> createDatXe(Map<String, dynamic> data) async {
    final url = '$baseUrl/datxe';
    try {
      final response = await http.post(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      }, body: jsonEncode(data));
      return response.statusCode == 201;
    } catch (e) {
      print('Error while creating datxe: $e');
      return false;
    }
  }

  Future<bool> updateDatXe(String id, Map<String, dynamic> data) async {
    final url = '$baseUrl/datxe/$id';
    try {
      final response = await http.put(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      }, body: jsonEncode(data));
      return response.statusCode == 200;
    } catch (e) {
      print('Error while updating datxe: $e');
      return false;
    }
  }

  Future<bool> deleteDatXe(String id) async {
    final url = '$baseUrl/datxe/$id';
    try {
      final response = await http.delete(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      print('Error while deleting datxe: $e');
      return false;
    }
  }
}
