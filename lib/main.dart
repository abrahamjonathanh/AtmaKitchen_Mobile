import 'package:atmakitchen_mobile/firebase_options.dart';
import 'package:atmakitchen_mobile/presentation/auth/login.dart';
import 'package:atmakitchen_mobile/presentation/general/general.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // Ensure initialized
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  // Firebase initialize
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      // home: const LoginScreen()
      home: const GeneralScreen(),
    );
  }
}
