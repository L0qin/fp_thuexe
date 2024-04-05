import 'dart:convert';
import 'dart:io';
import 'package:fp_thuexe/services/AuthService.dart';
import 'package:http/http.dart' as http;
import 'ServiceConstants.dart';

class OtherService {
  static const String baseUrl = "${ServiceConstants.baseUrl}/others";

  static Future<Map<String, dynamic>> getTerm(int id) async {
    final url = '$baseUrl/getTerm/$id';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      // Extracting 'term' object from the response
      final term = responseBody['term'];

      // Assuming the response structure matches the provided JSON,
      // extract 'tieu_de' and 'noi_dung' from the 'term' object
      return {
        'title': term['tieu_de'], // Use 'tieu_de' from the 'term' object
        'content': term['noi_dung'] // Use 'noi_dung' from the 'term' object
      };
    } else {
      throw Exception('Failed to load term');
    }
  }

  static Future<Map<int, Map<String, dynamic>>> getVouchers() async {
    final url = '$baseUrl/getVouchers';
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.authorizationHeader: token,
      },
    );

    if (response.statusCode == 200) {
      final vouchers = json.decode(response.body)['vouchers'];
      return Map.fromIterable(vouchers,
          key: (voucher) => voucher['ma_voucher'],
          value: (voucher) => {
            'ma_code': voucher['ma_code'],
            'mo_ta': voucher['mo_ta'],
            'phan_tram_giam': voucher['phan_tram_giam'],
            'so_tien_giam': voucher['so_tien_giam'],
            'ngay_bat_dau': voucher['ngay_bat_dau'],
            'ngay_ket_thuc': voucher['ngay_ket_thuc'],
            'dieukien_apdung': voucher['dieukien_apdung'],
            'trang_thai': voucher['trang_thai'],
          });
    } else {
      throw Exception('Failed to load vouchers');
    }
  }

}
