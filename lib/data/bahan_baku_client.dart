import 'dart:convert';

import 'package:atmakitchen_mobile/constants/variables.dart';
import 'package:http/http.dart';

class BahanBakuClient {
  static String url = AVariable.baseURL;

  static Future<Response> getAllBahanBaku() async {
    try {
      var response = await get(Uri.http(url, '/api/bahan-baku'), headers: {
        "Content-Type": "application/json",
      });

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> getBahanBakuUsage(
      String startDate, String endDate) async {
    try {
      var response = await post(Uri.http(url, '/api/bahan-baku/laporan'),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({"start_date": startDate, "end_date": endDate}));

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
