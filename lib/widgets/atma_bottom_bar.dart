import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailwind_colors/tailwind_colors.dart';

class AtmaBottomBar extends StatelessWidget {
  final List<BottomNavigationBarItem> items;
  final int currentIndex;
  final List<Widget Function()> routes;

  const AtmaBottomBar({
    Key? key,
    required this.items,
    required this.currentIndex,
    required this.routes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: items,
      backgroundColor: Colors.white,
      elevation: 15.0,
      currentIndex: currentIndex,
      selectedItemColor:
          TW3Colors.orange.shade600, // Change to your desired color
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      unselectedItemColor: Colors.black,
      onTap: (index) {
        if (index < routes.length) {
          // Navigate to the selected route
          Get.to(routes[index]());
        }
      },
    );
  }
}
