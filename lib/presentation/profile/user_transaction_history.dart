import 'package:atmakitchen_mobile/constants/constants.dart';
import 'package:atmakitchen_mobile/data/user_client.dart';
import 'package:atmakitchen_mobile/domain/product.dart';
import 'package:atmakitchen_mobile/domain/transaction.dart';
import 'package:atmakitchen_mobile/widgets/atma_bottom_bar.dart';
import 'package:atmakitchen_mobile/widgets/atma_transaction_card.dart';
import 'package:flutter/material.dart';

class UserTransactionHistory extends StatefulWidget {
  const UserTransactionHistory({super.key});

  @override
  State<UserTransactionHistory> createState() => _UserTransactionHistoryState();
}

class _UserTransactionHistoryState extends State<UserTransactionHistory> {
  Future<List<Transaction>>? transaction;

  void onGetCustomerTransactionHistory() async {
    var response =
        await UserClient.getCustomerById(int.parse(box.read("id_user")));
    if (response['data'] != null) {
      List data = response['data']['histori_pesanan'] as List;

      List<Transaction> transactionData = data
          .map((transaction) => Transaction(
                idPesanan: transaction['id_pesanan'].toString(),
                idMetodePembayaran:
                    int.parse(transaction['id_metode_pembayaran'].toString()),
                idPelanggan: int.parse(transaction['id_pelanggan'].toString()),
                tglOrder: transaction['tgl_order'].toString(),
                totalDiskonPoin:
                    int.parse(transaction['total_diskon_poin'].toString()),
                totalPesanan:
                    int.parse(transaction['total_pesanan'].toString()),
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
                // detailPesanan: (transaction['detail_pesanan']
                //         as List<DetailTransaction>)
                //     .map((detail) => DetailTransaction(
                //           idDetailPesanan: detail.idDetailPesanan.toString(),
                //           idPesanan: detail.idPesanan.toString(),
                //           idProduk: int.parse(detail.idProduk.toString()),
                //           idProdukHampers: detail.idProdukHampers != null
                //               ? int.parse(detail.idProdukHampers.toString())
                //               : null,
                //           kategori: detail.kategori,
                //           namaProduk: detail.namaProduk,
                //           harga: int.parse(detail.namaProduk.toString()),
                //           jumlah: int.parse(detail.jumlah.toString()),
                //           createdAt: detail.createdAt,
                //           updatedAt: detail.updatedAt,
                //           deletedAt: detail.deletedAt,
                //           // produk: detail['produk'] != null
                //           //     ? Product.fromJson(detail['produk'])
                //           //     : null,
                //         ))
                //     .toList(),
                detailPesanan: (transaction['detail_pesanan'] as List)
                    .map((detail) => DetailTransaction.fromJson(detail))
                    .toList(),
              ))
          .toList();
      setState(() {
        transaction = Future.value(transactionData);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    onGetCustomerTransactionHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Transaksi"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 500.0,
                child: FutureBuilder(
                    future: transaction,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Error: ${snapshot.error}"),
                        );
                      }
                      if (snapshot.hasData) {
                        final data = snapshot.data!;
                        debugPrint(data.toString());

                        // return ListView.separated(
                        //     scrollDirection: Axis.vertical,
                        //     separatorBuilder: (_, __) =>
                        //         const SizedBox(height: 16.0),
                        //     itemCount: data.length,
                        //     shrinkWrap: true,
                        //     itemBuilder: (_, index) {
                        //       return Container(
                        //           height: 200.0,
                        //           child: Column(
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             children: [
                        //               Text(data[index].idPesanan),
                        //               Container(
                        //                 height: 180,
                        //                 child: ListView.separated(
                        //                   separatorBuilder: (_, __) =>
                        //                       const SizedBox(
                        //                     height: 16.0,
                        //                   ),
                        //                   itemCount:
                        //                       data[index].detailPesanan!.length,
                        //                   itemBuilder: (_, index) {
                        //                     return Container(
                        //                       // height: 20,
                        //                       child: Text("HEY"),
                        //                     );
                        //                   },
                        //                 ),
                        //               )
                        //             ],
                        //           ));
                        //     });
                        return ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                  height: 250,
                                  color: Colors.amber[[600, 500, 100][index]],
                                  child: Column(
                                    children: [
                                      Center(
                                          child: Text(data[index].idPesanan)),
                                      Container(
                                        height: 230,
                                        child: ListView.builder(
                                            itemCount: data[index]
                                                .detailPesanan
                                                ?.length,
                                            itemBuilder: (_, int detailIndex) {
                                              return AtmaTransactionCard(
                                                  nama: data[index]
                                                      .detailPesanan![
                                                          detailIndex]
                                                      .namaProduk,
                                                  ukuran: data[index]
                                                      .detailPesanan![
                                                          detailIndex]
                                                      .produk!
                                                      .ukuran,
                                                  thumbnail: data[index]
                                                      .detailPesanan![
                                                          detailIndex]
                                                      .produk!
                                                      .thumbnail!,
                                                  jumlah: data[index]
                                                      .detailPesanan![
                                                          detailIndex]
                                                      .jumlah,
                                                  harga: data[index]
                                                      .detailPesanan![
                                                          detailIndex]
                                                      .harga,
                                                  total: data[index]
                                                          .detailPesanan![
                                                              detailIndex]
                                                          .harga *
                                                      data[index]
                                                          .detailPesanan![
                                                              detailIndex]
                                                          .jumlah);

                                              // Container(
                                              //   height: 25,
                                              //   child: Text(data[index]
                                              //       .detailPesanan![detailIndex]
                                              //       .namaProduk),
                                              // );
                                            }),
                                      )
                                    ],
                                  ));
                            });
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AtmaBottomBar(
        currentIndex: 1,
      ),
    );
  }
}
