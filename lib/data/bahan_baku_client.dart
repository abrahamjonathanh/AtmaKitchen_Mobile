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
}
