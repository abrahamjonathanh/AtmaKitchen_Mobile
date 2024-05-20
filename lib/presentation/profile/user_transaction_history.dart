import 'package:atmakitchen_mobile/constants/constants.dart';
import 'package:atmakitchen_mobile/data/user_client.dart';
import 'package:atmakitchen_mobile/domain/transaction.dart';
import 'package:atmakitchen_mobile/presentation/home/user_home.dart';
import 'package:atmakitchen_mobile/presentation/presence/presence.dart';
import 'package:atmakitchen_mobile/presentation/profile/profile.dart';
import 'package:atmakitchen_mobile/widgets/atma_bottom_bar.dart';
import 'package:atmakitchen_mobile/widgets/atma_text_field.dart';
import 'package:atmakitchen_mobile/widgets/atma_transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:tailwind_colors/tailwind_colors.dart';

class UserTransactionHistory extends StatefulWidget {
  const UserTransactionHistory({super.key});

  @override
  State<UserTransactionHistory> createState() => _UserTransactionHistoryState();
}

class _UserTransactionHistoryState extends State<UserTransactionHistory> {
  Future<List<Transaction>>? transaction;
  List<Transaction> filteredTransaction = [];
  TextEditingController searchController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  void onGetCustomerTransactionHistory() async {
    var response =
        await UserClient.getCustomerById(int.parse(box.read("id_user")));
    if (response['data'] != null) {
      List data = response['data']['histori_pesanan'] as List;
      debugPrint(data[1]['status_pesanan_latest'].toString());

      List<Transaction> transactionData = data
          .map((transaction) => Transaction(
              idPesanan: transaction['id_pesanan'].toString(),
              idMetodePembayaran:
                  int.parse(transaction['id_metode_pembayaran'].toString()),
              idPelanggan: int.parse(transaction['id_pelanggan'].toString()),
              tglOrder: transaction['tgl_order'].toString(),
              totalDiskonPoin:
                  int.parse(transaction['total_diskon_poin'].toString()),
              totalPesanan: int.parse(transaction['total_pesanan'].toString()),
              totalSetelahDiskon:
                  int.parse(transaction['total_setelah_diskon'].toString()),
              totalDibayarkan: transaction['total_dibayarkan'] != null
                  ? int.parse(transaction['total_dibayarkan'].toString())
                  : null,
              totalTip: int.parse(transaction['total_tip'].toString()),
              jenisPengiriman: transaction['jenis_pengiriman'].toString(),
              buktiPembayaran: transaction['bukti_pembayaran'],
              verifiedAt: transaction['verified_at'],
              acceptedAt: transaction['accepted_at'],
              createdAt: transaction['created_at'],
              updatedAt: transaction['updated_at'],
              deletedAt: transaction['deleted_at'],
              detailPesanan: (transaction['detail_pesanan'] as List)
                  .map((detail) => DetailTransaction.fromJson(detail))
                  .toList(),
              statusPesananLatest: transaction['status_pesanan_latest'] != null
                  ? TransactionStatus.fromJson(
                      transaction['status_pesanan_latest'])
                  : null))
          .toList();
      setState(() {
        transaction = Future.value(transactionData);
        filteredTransaction = transactionData;
      });
    }
  }

// Method to filter transactions based on product name
  List<Transaction> filterTransactions(
      String query, List<Transaction> transactions) {
    if (query.isEmpty) {
      return transactions; // Return all transactions if the query is empty
    }
    return transactions.where((transaction) {
      return transaction.detailPesanan!.any((detail) =>
          detail.namaProduk.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    onGetCustomerTransactionHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TW3Colors.slate.shade200,
      appBar: AppBar(
        title: const Text("Riwayat Transaksi"),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
                future: transaction,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    // final data = filteredTransaction;
                    return Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Container(
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            padding: const EdgeInsets.all(16.0),
                            child: AtmaTextField(
                              key: const ValueKey("searchKey"),
                              title: "Cari nama produk....",
                              controller: searchController,
                              onSubmitted: (value) {
                                setState(() {
                                  filteredTransaction = filterTransactions(
                                      searchController.text, data);
                                });
                              },
                            ),
                          ),
                          if (filteredTransaction.isEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16.0),
                              // decoration: BoxDecoration(color: Colors.white),
                              child: Text(
                                  'Produk ${searchController.text} tidak ditemukan'),
                            ),
                          ...filteredTransaction
                              .map((e) => Column(
                                    children: [
                                      Container(
                                          decoration: const BoxDecoration(
                                              color: Colors.white),
                                          child: AtmaTransactions(
                                            idPesanan: e.idPesanan,
                                            total: e.totalSetelahDiskon,
                                            detailPesanan: e.detailPesanan!,
                                            transactionStatus:
                                                e.statusPesananLatest,
                                          )),
                                      const SizedBox(
                                        height: 16.0,
                                      )
                                    ],
                                  ))
                              .toList(),
                        ],
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                })
          ],
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
