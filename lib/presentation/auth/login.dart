import 'dart:convert';
import 'dart:io';

import 'package:atmakitchen_mobile/constants/constants.dart';
import 'package:atmakitchen_mobile/constants/styles.dart';
import 'package:atmakitchen_mobile/data/user_client.dart';
import 'package:atmakitchen_mobile/domain/user.dart';
import 'package:atmakitchen_mobile/presentation/auth/forgot_password.dart';
import 'package:atmakitchen_mobile/presentation/presence/presence.dart';
import 'package:atmakitchen_mobile/presentation/profile/profile.dart';
import 'package:atmakitchen_mobile/widgets/atma_button.dart';
import 'package:atmakitchen_mobile/widgets/atma_notification.dart';
import 'package:atmakitchen_mobile/widgets/atma_text_field.dart';
// import 'package:atmakitchen_mobile/widgets/atma_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailwind_colors/tailwind_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final NotificationSetup _notification = NotificationSetup();

  void getDeviceKey() async {
    if (Platform.isAndroid) {
      final String? token = await FirebaseMessaging.instance.getToken();
      debugPrint(token);
    }
  }

  @override
  void initState() {
    _notification.configurePushNotifications(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    final formKey = GlobalKey<FormState>();
    // String? accessToken;
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
      if (response.statusCode == 200) {
        box.write('token', data['access_token']);

        var response = await UserClient.getCurrentUser(box.read("token"));

        if (response['data'] != null) {
          var data = response['data'];
          Account accountData = Account.fromJson(data['akun']);

          Customer customerData = Customer(
              idAkun: data['id_akun'],
              idPelanggan: data['id_pelanggan'],
              nama: data['nama'],
              akun: accountData);
          debugPrint(customerData.idPelanggan.toString());
          box.write("id_user", customerData.idPelanggan.toString());
          if (accountData.role!.role == 'Customer') {
            return Get.to(const UserProfileScreen());
          }
          return Get.to(const PresenceScreen());
        }

        showSnackBar(data['error']);
      }
    }

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
              AtmaButton(textButton: "Get KEY", onPressed: getDeviceKey),
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
                  )),
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
        ));
  }
}
