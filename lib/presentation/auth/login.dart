import 'dart:convert';
import 'dart:io';

import 'package:atmakitchen_mobile/constants/styles.dart';
import 'package:atmakitchen_mobile/data/user_client.dart';
import 'package:atmakitchen_mobile/domain/user.dart';
import 'package:atmakitchen_mobile/presentation/auth/forgot_password.dart';
import 'package:atmakitchen_mobile/presentation/home/user_home.dart';
import 'package:atmakitchen_mobile/presentation/presence/presence.dart';
import 'package:atmakitchen_mobile/widgets/atma_button.dart';
import 'package:atmakitchen_mobile/widgets/atma_text_field.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tailwind_colors/tailwind_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final NotificationSetup _notification = NotificationSetup();
  final box = GetStorage();
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void getDeviceKey() async {
    if (Platform.isAndroid) {
      final String? token = await FirebaseMessaging.instance.getToken();
      debugPrint(token);
    }
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      print('User granted permission: ${settings.authorizationStatus}');
    });
  }

  @override
  void initState() {
    // _notification.configurePushNotifications(context);
    super.initState();
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void onLoginHandler() async {
    var response =
        await UserClient.login(emailController.text, passwordController.text);
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    debugPrint(data.toString());
    if (response.statusCode == 200) {
      box.write('token', data['access_token']);

      var userResponse = await UserClient.getCurrentUser(box.read("token"));

      if (userResponse['data'] != null) {
        var userData = userResponse['data'];
        Account accountData = Account.fromJson(userData['akun']);

        Customer customerData = Customer(
            idAkun: userData['id_akun'],
            idPelanggan: userData['id_pelanggan'],
            nama: userData['nama'],
            akun: accountData);
        debugPrint(customerData.idPelanggan.toString());
        box.write("id_user", customerData.idPelanggan.toString());
        if (accountData.role!.role == 'Customer') {
          Get.offAll(() => const UserHomeScreen());
        } else {
          Get.offAll(() => const PresenceScreen());
        }
      } else {
        showSnackBar("Failed to fetch user data");
      }
    } else {
      showSnackBar(data['error']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "AtmaKitchen",
              style: AStyle.textStyleHeader,
            ),
            const SizedBox(
              height: 8.0,
            ),
            // AtmaButton(textButton: "Get KEY", onPressed: getDeviceKey),
            Form(
              key: formKey,
              child: Column(
                children: [
                  AtmaTextField(
                    key: const ValueKey("emailKey"),
                    title: "Email",
                    controller: emailController,
                    mandatory: true,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  AtmaTextField(
                    key: const ValueKey("passwordKey"),
                    title: "Password",
                    controller: passwordController,
                    mandatory: true,
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => Get.to(const UserForgotPasswordScreen()),
                      child: Text(
                        "Lupa Password?",
                        style: AStyle.textStyleNormal,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  AtmaButton(
                    textButton: "Login",
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        onLoginHandler();
                      }
                    },
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => const RegisterScreen()));
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32.0, top: 8.0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Belum memiliki akun? ",
                  style: AStyle.textStyleNormal
                      .copyWith(color: TW3Colors.slate.shade600),
                ),
                TextSpan(
                    text: "Daftar sekarang.",
                    style: AStyle.textStyleNormal
                        .copyWith(decoration: TextDecoration.underline)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
