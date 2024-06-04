import 'dart:convert';

import 'package:atmakitchen_mobile/constants/variables.dart';
import 'package:http/http.dart';

class TransactionClient {
  static String url = AVariable.baseURL;

  static Future<Response> updateStatusPesanan(
      String id_pesanan, String status) async {
    try {
      var response =
          await post(Uri.http(url, '/api/pesanan/status/$id_pesanan'),
              headers: {
                "Content-Type": "application/json",
              },
              body: jsonEncode({
                "status": status,
              }));

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
