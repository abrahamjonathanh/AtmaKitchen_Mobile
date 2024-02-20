import 'package:atmakitchen_mobile/widgets/atma_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(children: [
            const Text("Login"),
            AtmaButton(
              textButton: "Login",
              onPressed: () {},
            )
          ]),
        ),
      ),
    );
  }
}
