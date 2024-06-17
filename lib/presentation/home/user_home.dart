import 'dart:convert';

import 'package:atmakitchen_mobile/constants/constants.dart';
import 'package:atmakitchen_mobile/constants/styles.dart';
import 'package:atmakitchen_mobile/data/product_client.dart';
import 'package:atmakitchen_mobile/domain/product.dart';
import 'package:atmakitchen_mobile/presentation/general/general.dart';
import 'package:atmakitchen_mobile/presentation/home/product_detail.dart';
import 'package:atmakitchen_mobile/presentation/profile/profile.dart';
import 'package:atmakitchen_mobile/widgets/atma_bottom_bar.dart';
import 'package:atmakitchen_mobile/widgets/atma_product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tailwind_colors/tailwind_colors.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  Future<List<Product>>? product;
  Future<List<Hampers>>? hampers;

  List<Product> filteredProduct = [];
  List<Hampers> filteredHampers = [];

  TextEditingController searchController = TextEditingController();

  void getAllProduct() async {
    var response = await ProductClient.getAllProduct(
        DateFormat('yyyy-MM-dd').format(DateTime.now()));

    // var response = await UserClient.getAllEmployee(box.read("token"));

    Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<Product> productData = (data['data'] as List)
          .map((item) => Product(
                idProduk: item['id_produk'],
                idKategori: item['id_kategori'],
                nama: item['nama'],
                kapasitas: item['kapasitas'],
                ukuran: item['ukuran'],
                hargaJual: item['harga_jual'],
                thumbnail: ProductThumbnail.fromJson(item['thumbnail']),
                readyStock: item['ready_stock'],
              ))
          .toList();

      setState(() {
        product = Future.value(productData);
        filteredProduct = productData;
      });
    }
  }

  void getAllHampers() async {
    var response = await ProductClient.getAllHampers();

    Map<String, dynamic> data = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      List<Hampers> hampersData =
          (data['data'] as List).map((item) => Hampers.fromJson(item)).toList();

      setState(() {
        hampers = Future.value(hampersData);
        filteredHampers = hampersData;
      });
    }
  }

  List<Product> filterProducts(String query, List<Product> product) {
    if (query.isEmpty) {
      return product; // Return all presences if the query is empty
    }
    return product.where((product) {
      return product.nama.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  List<Hampers> filterHampers(String query, List<Hampers> hampers) {
    if (query.isEmpty) {
      return hampers;
    }
    return hampers.where((hampers) {
      return hampers.nama.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    getAllProduct();
    getAllHampers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TW3Colors.slate.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Home"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Produk Kami",
                style: AStyle.textStyleTitleLg,
              ),
              const SizedBox(
                height: 16.0,
              ),
              GridView.builder(
                itemCount: filteredProduct.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 22 / 35,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemBuilder: (context, index) {
                  final product = filteredProduct[index];
                  return GestureDetector(
                    onTap: () => {
                      Get.to(ProductDetailScreen(
                        produk: filteredProduct[index],
                      ))
                    },
                    child: AtmaProductCard(
                        thumbnail: product.thumbnail?.image ??
                            "https://via.placeholder.com/640x480.png/00ff55?text=aut",
                        nama: product.nama,
                        ukuran: product.ukuran,
                        hargaJual: product.hargaJual,
                        readyStock: product.readyStock),
                  );
                },
              ),
              const SizedBox(
                height: 24.0,
              ),
              Text(
                "Produk Hampers",
                style: AStyle.textStyleTitleLg,
              ),
              const SizedBox(
                height: 16.0,
              ),
              GridView.builder(
                itemCount: filteredHampers.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 22 / 35,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemBuilder: (context, index) {
                  final product = filteredHampers[index];
                  return GestureDetector(
                    onTap: () => {
                      Get.to(ProductDetailHampersScreen(
                        hampers: filteredHampers[index],
                      ))
                    },
                    child: AtmaProductCard(
                      thumbnail: product.image,
                      nama: product.nama,
                      hargaJual: product.hargaJual,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AtmaBottomBar(
        currentIndex: 1,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'Profile',
          ),
        ],
        routes: <Widget Function()>[
          () => const GeneralScreen(),
          () => const UserHomeScreen(),
          () => box.read('token') != null
              ? const UserProfileScreen()
              : const UserUnauthenticatedScreen()
        ],
      ),
    );
  }
}
