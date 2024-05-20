import 'package:atmakitchen_mobile/presentation/profile/profile.dart';
import 'package:atmakitchen_mobile/widgets/atma_bottom_bar.dart';
import 'package:flutter/material.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [Text("UserHomeScreen")],
      ),
      bottomNavigationBar: AtmaBottomBar(
        currentIndex: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        routes: <Widget Function()>[
          () => const UserHomeScreen(),
          () => const UserProfileScreen(),
        ],
      ),
    );
  }
}
