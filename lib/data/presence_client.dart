import 'dart:convert';

import 'package:atmakitchen_mobile/constants/variables.dart';
import 'package:atmakitchen_mobile/domain/user.dart';
import 'package:http/http.dart';

class PresenceClient {
  static String url = AVariable.baseURL;

  static Future<Map<String, dynamic>> getAllPresence() async {
    try {
      var response = await get(
        Uri.http(url, "/api/presensi"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 401) {
        // If credentials are not valid
      }

      return jsonDecode(response.body);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> getAllPresenceByDate(
      String accessToken, DateTime? date) async {
    try {
      String dateString = date?.toIso8601String() ?? '';

      var response = await get(
          Uri.http(url, "/api/presensi/karyawan",
              {'date': dateString.split("T")[0]}),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken"
          });
      print(response.toString());
      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> updatePresenceByEmployeeId(
      String accessToken, DateTime date, Employee employee) async {
    try {
      String dateString = date.toIso8601String();

      var response = await post(Uri.http(url, "/api/presensi"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken"
          },
          body: jsonEncode({
            "id_karyawan": employee.idKaryawan,
            "tanggal": dateString.split("T")[0]
          }));
      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> deletePresenceByEmployeeId(
      String accessToken, int id) async {
    try {
      var response = await delete(
        Uri.http(url, "/api/presensi/$id"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken"
        },
      );
      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
