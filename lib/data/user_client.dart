import 'dart:convert';

import 'package:atmakitchen_mobile/constants/constants.dart';
import 'package:atmakitchen_mobile/constants/variables.dart';
import 'package:http/http.dart';

// GetX Connect Docs
// class UserProvider extends GetConnect {
//   // Get request
//   Future<Response> getUser(int id) => get('http://youapi/users/$id');
//   // Post request
//   Future<Response> postUser(Map data) => post('http://youapi/users', body: data);
//   // Post request with File
//   Future<Response<CasesModel>> postCases(List<int> image) {
//     final form = FormData({
//       'file': MultipartFile(image, filename: 'avatar.png'),
//       'otherFile': MultipartFile(image, filename: 'cover.png'),
//     });
//     return post('http://youapi/users/upload', form);
//   }

//   GetSocket userMessages() {
//     return socket('https://yourapi/users/socket');
//   }
// }

class UserClient {
  static String url = AVariable.baseURL;

  static Future<Response> login(String email, String password) async {
    try {
      var response = await post(Uri.http(url, "/api/auth/login"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"email": email, "password": password}));

      if (response.statusCode == 401) {
        // If credentials are not valid
      }

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Map<String, dynamic>> getCurrentUser(String accessToken) async {
    try {
      var response = await get(Uri.http(url, "/api/auth/me"), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken"
      });

      return jsonDecode(response.body);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Map<String, dynamic>> getCustomerById(int id) async {
    try {
      var token = box.read("token");

      var response = await get(Uri.http(url, '/api/pelanggan/$id'), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      });

      return jsonDecode(response.body);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Map<String, dynamic>> getEmployeeById(int id) async {
    try {
      var token = box.read("token");

      var response = await get(Uri.http(url, '/api/karyawan/$id'), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      });

      return jsonDecode(response.body);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> verifyOTP(String email, String otp) async {
    try {
      var response = await post(Uri.http(url, '/api/auth/verify'),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({"email": email, "otp": otp}));

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // static Future<Map<String, dynamic>> sendOTP(String email) async {
  //   try {
  //     var response = await post(Uri.http(url, '/api/auth/send-otp'),
  //         headers: {
  //           "Content-Type": "application/json",
  //         },
  //         body: jsonEncode({
  //           "email": email,
  //         }));

  //     return jsonDecode(response.body);
  //   } catch (e) {
  //     return Future.error(e.toString());
  //   }
  // }

  static Future<Response> sendOTP(String email) async {
    try {
      var response = await post(Uri.http(url, '/api/auth/send-otp'),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "email": email,
          }));

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> resetPassword(
      String email, String otp, String password) async {
    try {
      var response = await post(Uri.http(url, '/api/auth/reset'),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({"email": email, "otp": otp, "password": password}));

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> getAllEmployee(String accessToken) async {
    try {
      var response = await get(Uri.http(url, "/api/karyawan"), headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken"
      });

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
