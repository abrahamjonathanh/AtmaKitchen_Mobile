import 'package:atmakitchen_mobile/constants/styles.dart';
import 'package:atmakitchen_mobile/presentation/home/user_home.dart';
import 'package:atmakitchen_mobile/widgets/atma_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'saldo_pelanggan_screen.dart'; // import new screen

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Profile",
            style: AStyle.textStyleTitleLg,
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Info Pengguna"),
              Tab(text: "Saldo Pelanggan"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            UserProfileInfo(),
            SaldoPelangganScreen(),
          ],
        ),
        bottomNavigationBar: AtmaBottomBar(
          currentIndex: 1,
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
      ),
    );
  }
}

class UserProfileInfo extends StatelessWidget {
  const UserProfileInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This is where you can add other user information
    return Center(
      child: Text("Informasi Pengguna"),
    );
  }
}
