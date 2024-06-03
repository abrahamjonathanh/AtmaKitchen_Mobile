import 'package:http/http.dart' as http;
import 'package:atmakitchen_mobile/constants/variables.dart';
import 'dart:convert';

class SaldoClient {
  static String url = AVariable.baseURL;

  static Future<http.Response> getSaldo(String userId) async {
    try {
      var response = await http.get(
        Uri.http(url, '/api/saldo/$userId'),
        headers: {"Content-Type": "application/json"},
      );
      return response;
    } catch (e) {
      print('Error in getSaldo: $e');
      return Future.error(e.toString());
    }
  }

  static Future<http.Response> withdrawSaldo(
      Map<String, dynamic> payload) async {
    try {
      print('Sending withdraw request with payload: $payload');
      var response = await http.post(
        Uri.http(url, '/api/penarikan-saldo'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );
      print('withdrawSaldo response status: ${response.statusCode}');
      print('withdrawSaldo response body: ${response.body}');
      return response;
    } catch (e) {
      print('Error in withdrawSaldo: $e');
      return Future.error(e.toString());
    }
  }

  static Future<http.Response> getWithdrawalHistory(String userId) async {
    try {
      var response = await http.get(
        Uri.http(url, '/api/penarikan-saldo/user/$userId'),
        headers: {"Content-Type": "application/json"},
      );
      return response;
    } catch (e) {
      print('Error in getWithdrawalHistory: $e');
      return Future.error(e.toString());
    }
  }

  static Future<http.Response> submitPenarikanSaldo(
      Map<String, String> penarikanData) async {
    try {
      var response = await http.post(
        Uri.http(url, '/api/penarikan-saldo'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(penarikanData),
      );
      return response;
    } catch (e) {
      print('Error in submitPenarikanSaldo: $e');
      return Future.error(e.toString());
    }
  }
}
