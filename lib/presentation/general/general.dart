import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GeneralScreen extends StatelessWidget {
  final List<Map<String, dynamic>> statistics = [
    {"title": "Testimoni", "count": 203},
    {"title": "Produk", "count": 33},
    {"title": "Partner", "count": 10},
  ];

  final List<List<Map<String, String>>> testimonialData = [
    [
      {
        "avatar": "assets/avatars/Stephanie.png",
        "fullname": "Stephanie",
        "username": "@stephanie78",
        "comment": "AtmaKitchen gue beli kemarin lgsg jatuh cinta. Seenak itu woii 😍😍💕",
      },
      {
        "avatar": "assets/avatars/Jessica.png",
        "fullname": "Jessica",
        "username": "@jessy",
        "comment": "Barusan dapat oleh2 dr teman, gila enak banget browniesnya! Lgsung cari tau dia beli dimana, rupanya di AtmaKitchen 😃",
      },
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AtmaKitchen"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
    );
  }
}

class HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
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
              Icon(Icons.notifications, color: Colors.orange),
              SizedBox(width: 8),
              Text("AtmaKitchen sekarang tersedia di Android dan iOS!"),
            ],
          ),
        ),
        SizedBox(height: 16),
        Center(
          child: Image.asset(
            'assets/images/Hero.png',
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 16),
        Text(
          "Atma Kitchen",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          "Selamat datang di Atma Kitchen, destinasi terbaik untuk menemukan berbagai pilihan roti, kue, dan produk lezat lainnya yang bermutu tinggi. Kami berkomitmen untuk memberikan pelayanan dan kualitas terbaik.",
        ),
        SizedBox(height: 16),
         ElevatedButton(
            onPressed: () => _launchURL('https://atma-kitchen-v2.vercel.app/'),
            child: Text("Pesan Sekarang"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            ),
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

  TestimonialsSection({required this.testimonialData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Apa Kata Mereka?",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text("Pendapat pelanggan tentang menu dan pelayanan kami."),
        SizedBox(height: 16),
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
                        SizedBox(height: 8),
                        Text(
                          testimonial["comment"]!,
                          style: TextStyle(color: Colors.orange),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red, Colors.orange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Tunggu apa lagi?",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 8),
          Text(
            "Pesan dan kumpulkan poinmu sekarang!",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _launchURL('https://atma-kitchen-v2.vercel.app/'),
            child: Text("Pesan Sekarang"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
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
