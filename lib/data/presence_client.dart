import 'dart:convert';

import 'package:atmakitchen_mobile/constants/variables.dart';
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
}
