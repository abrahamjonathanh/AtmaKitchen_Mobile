import 'package:atmakitchen_mobile/pdf_view_transaksi_penitip.dart';
import 'package:atmakitchen_mobile/presentation/auth/login.dart';
import 'package:atmakitchen_mobile/presentation/home/user_home.dart';
import 'package:atmakitchen_mobile/presentation/profile/profile.dart';
import 'package:atmakitchen_mobile/widgets/atma_bottom_bar.dart';
import 'package:atmakitchen_mobile/widgets/atma_button.dart';
import 'package:atmakitchen_mobile/widgets/atma_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailwind_colors/tailwind_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:atmakitchen_mobile/pdf_view.dart';
import 'package:atmakitchen_mobile/pdf_view_pemasukan_pengeluaran.dart';

class GeneralScreen extends StatelessWidget {
  const GeneralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //   final List<Map<String, dynamic>> statistics = [
    //   {"title": "Testimoni", "count": 203},
    //   {"title": "Produk", "count": 33},
    //   {"title": "Partner", "count": 10},
    // ];

    const List<List<Map<String, String>>> testimonialData = [
      [
        {
          "avatar": "assets/avatars/Stephanie.png",
          "fullname": "Stephanie",
          "username": "@stephanie78",
          "comment":
              "AtmaKitchen gue beli kemarin lgsg jatuh cinta. Seenak itu woii 😍😍💕",
        },
        {
          "avatar": "assets/avatars/Jessica.png",
          "fullname": "Jessica",
          "username": "@jessy",
          "comment":
              "Barusan dapat oleh2 dr teman, gila enak banget browniesnya! Lgsung cari tau dia beli dimana, rupanya di AtmaKitchen 😃",
        },
      ],
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("AtmaKitchen"),
        automaticallyImplyLeading: false,
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Section
              HeroSection(),

              SizedBox(height: 32),
              TestimonialsSection(testimonialData: testimonialData),
              SizedBox(height: 32),
              CTASection(),
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
          () => const UserUnauthenticatedScreen()
        ],
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.notifications, color: TW3Colors.orange.shade600),
              const SizedBox(width: 8),
              const Expanded(
                child:
                    Text("AtmaKitchen sekarang tersedia di Android dan iOS!"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Image.asset(
            'assets/images/Hero.png',
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Atma Kitchen",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Selamat datang di Atma Kitchen, destinasi terbaik untuk menemukan berbagai pilihan roti, kue, dan produk lezat lainnya yang bermutu tinggi. Kami berkomitmen untuk memberikan pelayanan dan kualitas terbaik.",
        ),
        const SizedBox(height: 16),
        AtmaButton(
          onPressed: () => _launchURL('https://atma-kitchen-v2.vercel.app/'),
          textButton: "Pesan Sekarang",
        ),
      ],
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class TestimonialsSection extends StatelessWidget {
  final List<List<Map<String, String>>> testimonialData;

  const TestimonialsSection({super.key, required this.testimonialData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Apa Kata Mereka?",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text("Pendapat pelanggan tentang menu dan pelayanan kami."),
        const SizedBox(height: 16),
        Column(
          children: testimonialData.map((testimonialGroup) {
            return Column(
              children: testimonialGroup.map((testimonial) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(testimonial["avatar"]!),
                    ),
                    title: Text(testimonial["fullname"]!),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(testimonial["username"]!),
                        const SizedBox(height: 8),
                        Text(
                          testimonial["comment"]!,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class CTASection extends StatelessWidget {
  const CTASection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red, TW3Colors.orange.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Tunggu apa lagi?",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            "Pesan dan kumpulkan poinmu sekarang!",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _launchURL('https://atma-kitchen-v2.vercel.app/'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: const Text("Pesan Sekarang"),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class UserUnauthenticatedScreen extends StatefulWidget {
  const UserUnauthenticatedScreen({super.key});

  @override
  State<UserUnauthenticatedScreen> createState() =>
      _UserUnauthenticatedScreenState();
}

class _UserUnauthenticatedScreenState extends State<UserUnauthenticatedScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _yearController = TextEditingController();
  int _selectedMonth = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Masuk"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            AtmaListTile(
              title: "Masuk",
              icon: Icons.login,
              onTap: () => Get.to(const LoginScreen()),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PdfView(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_document),
                  SizedBox(width: 8),
                  Text(
                    "Cetak Laporan Stok Bahan Baku",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _yearController,
                    decoration: const InputDecoration(labelText: 'Year'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a year';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: _selectedMonth,
                    decoration: const InputDecoration(labelText: 'Month'),
                    items: List.generate(12, (index) {
                      return DropdownMenuItem(
                        value: index + 1,
                        child: Text('${index + 1}'),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        _selectedMonth = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  int year = int.parse(_yearController.text);
                  int month = _selectedMonth;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfViewPemasukanPengeluaran(
                        year: year,
                        month: month,
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_document),
                  SizedBox(width: 8),
                  Text(
                    "Cetak Laporan Pemasukan Pengeluaran",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  int year = int.parse(_yearController.text);
                  int month = _selectedMonth;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfViewTransaksiPenitip(
                        year: year,
                        month: month,
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_document),
                  SizedBox(width: 8),
                  Text(
                    "Cetak Laporan Rekap Transaksi Penitip",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AtmaBottomBar(
        currentIndex: 2,
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
          () => const UserUnauthenticatedScreen()
        ],
      ),
    );
  }
}
