import 'dart:convert';
import 'package:atmakitchen_mobile/constants/constants.dart';
import 'package:atmakitchen_mobile/presentation/profile/penarikan_saldo_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atmakitchen_mobile/constants/styles.dart';
import 'package:atmakitchen_mobile/data/saldo_client.dart';
import 'package:atmakitchen_mobile/domain/saldo.dart';
import 'package:atmakitchen_mobile/widgets/atma_button.dart';

class SaldoPelangganScreen extends StatefulWidget {
  const SaldoPelangganScreen({Key? key}) : super(key: key);

  @override
  _SaldoPelangganScreenState createState() => _SaldoPelangganScreenState();
}

class _SaldoPelangganScreenState extends State<SaldoPelangganScreen> {
  late Future<Saldo> saldo;
  late Future<List<PenarikanSaldo>> penarikanSaldo;

  @override
  void initState() {
    super.initState();
    saldo = getSaldo();
    penarikanSaldo = getPenarikanSaldo();
  }

  Future<Saldo> getSaldo() async {
    String userId = box.read("id_user");
    var response = await SaldoClient.getSaldo(userId);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      return Saldo.fromJson(data);
    } else {
      print('Failed to load saldo');
      Get.snackbar(
        'Error',
        'Failed to load saldo',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      throw Exception('Failed to load saldo');
    }
  }

  Future<List<PenarikanSaldo>> getPenarikanSaldo() async {
    String userId = box.read("id_user");
    var response = await SaldoClient.getWithdrawalHistory(userId);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      return List<PenarikanSaldo>.from(
        data.map((item) => PenarikanSaldo.fromJson(item)),
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to load penarikan saldo history',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      throw Exception('Failed to load penarikan saldo history');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Saldo Pelanggan",
          style: AStyle.textStyleTitleLg,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<Saldo>(
              future: saldo,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Saldo: ${data.totalSaldo}',
                          style: AStyle.textStyleTitleMd),
                      const SizedBox(height: 16.0),
                      AtmaButton(
                        textButton: "Penarikan Saldo",
                        onPressed: () async {
                          String userId = box.read("id_user");
                          bool? result = await Get.to(
                            () => PenarikanSaldoScreen(
                              totalSaldo: data.totalSaldo,
                              idAkun: userId,
                            ),
                          );
                          if (result == true) {
                            setState(() {
                              saldo = getSaldo();
                              penarikanSaldo = getPenarikanSaldo();
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Text("Riwayat Penarikan Saldo",
                          style: AStyle.textStyleTitleMd),
                    ],
                  );
                }
                return const Center(child: Text("No data available"));
              },
            ),
            const SizedBox(height: 16.0),
            FutureBuilder<List<PenarikanSaldo>>(
              future: penarikanSaldo,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final penarikan = data[index];
                        return ListTile(
                          title: Text(
                              'Jumlah: ${penarikan.jumlahPenarikan.toString()}'),
                          subtitle: Text(
                              'Status: ${penarikan.status.toString()}, Tanggal: ${penarikan.createdAt.toString()}'),
                        );
                      },
                    ),
                  );
                }
                return const Center(child: Text("No data available"));
              },
            ),
          ],
        ),
      ),
    );
  }
}
