import 'package:atmakitchen_mobile/domain/product.dart';
import 'package:atmakitchen_mobile/presentation/profile/profile.dart';
import 'package:atmakitchen_mobile/widgets/atma_bottom_bar.dart';
import 'package:atmakitchen_mobile/widgets/atma_product_card.dart';
import 'package:flutter/material.dart';
import 'package:tailwind_colors/tailwind_colors.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  @override
  Widget build(BuildContext context) {
    List<Product> products = [
      Product(
          nama: "Lapis Legit",
          ukuran: "20x20 cm",
          hargaJual: 250000,
          idKategori: 1,
          idProduk: 1,
          kapasitas: 20),
      Product(
          nama: "Lapis Legit",
          ukuran: "20x20 cm",
          hargaJual: 250000,
          idKategori: 1,
          idProduk: 1,
          kapasitas: 20),
      Product(
          nama: "Lapis Legit",
          ukuran: "20x20 cm",
          hargaJual: 250000,
          idKategori: 1,
          idProduk: 1,
          kapasitas: 20)
    ].toList();
    return Scaffold(
      backgroundColor: TW3Colors.slate.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text("UserHomeScreen"),
              // ...products.map((data) => AtmaProductCard(
              //       nama: data.nama,
              //       ukuran: data.ukuran,
              //       hargaJual: data.hargaJual,
              //     )),
              GridView.builder(
                itemCount: products.length,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 22 / 30,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return AtmaProductCard(
                    nama: product.nama,
                    ukuran: product.ukuran,
                    hargaJual: product.hargaJual,
                  );
                },
              ),
            ],
          ),
        ),
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
