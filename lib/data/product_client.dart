import 'package:atmakitchen_mobile/constants/variables.dart';
import 'package:http/http.dart';

class ProductClient {
  static String url = AVariable.baseURL;

  static Future<Response> getAllProduct(String date) async {
    try {
      var response =
          await get(Uri.http(url, '/api/produk/tanggal/$date'), headers: {
        "Content-Type": "application/json",
      });

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> getAllHampers() async {
    try {
      var response = await get(Uri.http(url, "/api/hampers"), headers: {
        "Content-Type": "application/json",
      });

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
