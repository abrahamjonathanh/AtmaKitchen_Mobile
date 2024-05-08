import 'package:atmakitchen_mobile/constants/palettes.dart';
import 'package:atmakitchen_mobile/presentation/presence/presence.dart';
import 'package:atmakitchen_mobile/presentation/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AtmaBottomBar extends StatefulWidget {
  final int? currentIndex;

  const AtmaBottomBar({Key? key, this.currentIndex = 0}) : super(key: key);

  @override
  State<AtmaBottomBar> createState() => _AtmaBottomBarState();
}

class _AtmaBottomBarState extends State<AtmaBottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      backgroundColor: Colors.white,
      elevation: 15.0,
      currentIndex: widget.currentIndex!,
      selectedItemColor: APalette.primary,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      unselectedItemColor: Colors.black,
      onTap: (index) {
        switch (index) {
          case 0:
            Get.to(const PresenceScreen());
            // Navigator.of(context).push(
            // MaterialPageRoute(builder: (context) => const HomeScreen()));
            break;
          case 1:
            Get.to(const UserProfileScreen());
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (context) => CartScreen(id: userId ?? 1)));
            break;
          case 2:
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (context) => const UserProfileScreen()));
            break;
        }
      },
    );
  }
}
