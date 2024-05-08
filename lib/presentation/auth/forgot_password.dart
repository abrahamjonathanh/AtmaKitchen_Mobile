import 'dart:convert';

import 'package:atmakitchen_mobile/constants/styles.dart';
import 'package:atmakitchen_mobile/data/user_client.dart';
import 'package:atmakitchen_mobile/presentation/auth/login.dart';
import 'package:atmakitchen_mobile/widgets/atma_button.dart';
import 'package:atmakitchen_mobile/widgets/atma_loading.dart';
import 'package:atmakitchen_mobile/widgets/atma_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:tailwind_colors/tailwind_colors.dart';

class UserForgotPasswordScreen extends StatefulWidget {
  const UserForgotPasswordScreen({super.key});

  @override
  State<UserForgotPasswordScreen> createState() =>
      _UserForgotPasswordScreenState();
}

class _UserForgotPasswordScreenState extends State<UserForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool _isLoading = false;

    void showSnackBar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }

    void onSendOTPHandler() async {
      setState(() {
        _isLoading = true;
      });

      try {
        var response = await UserClient.sendOTP(emailController.text);

        if (response.statusCode == 200) {
          Get.to(UserVerifyOTPScreen(
            email: emailController.text,
          ));
          return;
        } else {
          showSnackBar("Error");
        }
      } catch (e) {
        showSnackBar("Error");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Lupa Password",
                style: AStyle.textStyleHeader,
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                "Kami akan mengirimkan One Time Password (OTP) ke email yang anda kirimkan",
                style: AStyle.textStyleNormal,
              ),
              const SizedBox(
                height: 16.0,
              ),
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
                    AtmaButton(
                      textButton: _isLoading ? "Loading..." : "Kirim OTP",
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          onSendOTPHandler();
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UserVerifyOTPScreen extends StatefulWidget {
  final String email;

  const UserVerifyOTPScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<UserVerifyOTPScreen> createState() => _UserVerifyOTPScreenState();
}

class _UserVerifyOTPScreenState extends State<UserVerifyOTPScreen> {
  bool _isLoading = false; // Add isLoading state variable

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void onVerifyOTPHandler(String otp) async {
    var response = await UserClient.verifyOTP(widget.email, otp);

    if (response.statusCode == 200) {
      return Get.to(UserResetPasswordScreen(email: widget.email, otp: otp));
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    showSnackBar(data['message']);
  }

  void onResendOTPHandler() async {
    setState(() {
      _isLoading = true; // Set isLoading back to false after the request
    });
    try {
      var response = await UserClient.sendOTP(widget.email);

      if (response.statusCode == 200) {
        Get.to(UserVerifyOTPScreen(
          email: widget.email,
        ));
      } else {
        showSnackBar("Email tidak ditemukan");
      }
    } catch (e) {
      showSnackBar("Error sending OTP");
    } finally {
      setState(() {
        _isLoading = false; // Set isLoading back to false after the request
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Verifikasi OTP",
              style: AStyle.textStyleHeader,
            ),

            const SizedBox(
              height: 16.0,
            ),
            Text(
                "Masukkan 4-digit kode verifikasi yang kami kirimkan ke ${widget.email}."),
            const SizedBox(
              height: 16.0,
            ),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: !_isLoading ? onResendOTPHandler : null,
                child: !_isLoading
                    ? Text(
                        "Kirim Ulang Kode",
                        style: AStyle.textStyleNormal,
                      )
                    : const AtmaLoading(),
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),
            // References: https://pub.dev/packages/flutter_otp_text_field
            OtpTextField(
              numberOfFields: 4,
              fieldWidth: 48.0,
              borderColor: TW3Colors.orange.shade600,
              focusedBorderColor: TW3Colors.orange.shade600,
              //set to true to show as box or false to show as dash
              showFieldAsBox: true,
              //runs when a code is typed in
              onCodeChanged: (String code) {
                //handle validation or checks here
              },
              //runs when every textfield is filled
              onSubmit: (String verificationCode) {
                onVerifyOTPHandler(verificationCode);
              }, // end onSubmit
            ),
          ],
        ),
      ),
    );
  }
}

class UserResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const UserResetPasswordScreen(
      {Key? key, required this.email, required this.otp})
      : super(key: key);

  @override
  State<UserResetPasswordScreen> createState() =>
      _UserResetPasswordScreenState();
}

class _UserResetPasswordScreenState extends State<UserResetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    void showSnackBar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }

    void onResetPassword() async {
      var response = await UserClient.resetPassword(
          widget.email, widget.otp, passwordController.text);
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        showSnackBar(data['message']);

        return Get.to(const LoginScreen());
      }

      showSnackBar(data['message']);
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Text(
              "Reset Password",
              style: AStyle.textStyleHeader,
            ),
            const SizedBox(
              height: 16.0,
            ),
            Form(
                key: formKey,
                child: Column(
                  children: [
                    AtmaTextField(
                      key: const ValueKey("passwordKey"),
                      title: "Email",
                      controller: passwordController,
                      mandatory: true,
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    AtmaButton(
                      textButton: "Reset Password",
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          onResetPassword();
                        }
                      },
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
