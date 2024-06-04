import 'package:atmakitchen_mobile/constants/variables.dart';
import 'package:http/http.dart';

class ReportClient {
  static String url = AVariable.baseURL;

  static Future<Response> getPengeluaranPemasukkan(int year, int month) async {
    try {
      var response = await get(
        Uri.http(url, '/api/laporan-pengeluaran-pemasukkan/$year/$month'),
        headers: {
          "Content-Type": "application/json",
        },
      );

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> getTransaksiPenitip(int year, int month) async {
    try {
      var response = await get(
        Uri.http(url, '/api/laporan-penitip/$year/$month'),
        headers: {
          "Content-Type": "application/json",
        },
      );

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
