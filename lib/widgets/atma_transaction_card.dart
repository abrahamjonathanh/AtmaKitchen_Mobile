import 'package:atmakitchen_mobile/constants/styles.dart';
import 'package:atmakitchen_mobile/data/transaction_client.dart';
import 'package:atmakitchen_mobile/domain/transaction.dart';
import 'package:atmakitchen_mobile/utils/utils.dart';
import 'package:atmakitchen_mobile/widgets/atma_button.dart';
import 'package:flutter/material.dart';
import 'package:tailwind_colors/tailwind_colors.dart';

class AtmaTransactions extends StatelessWidget {
  final String idPesanan;
  final int total;
  final List<DetailTransaction> detailPesanan;
  final TransactionStatus? transactionStatus;
  final void Function() onRefresh;

  const AtmaTransactions(
      {Key? key,
      required this.idPesanan,
      required this.total,
      required this.detailPesanan,
      this.transactionStatus,
      required this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    void onUpdateHandler() async {
      var response =
          await TransactionClient.updateStatusPesanan(idPesanan, "Selesai");
      if (response.statusCode == 200 || response.statusCode == 201) {
        onRefresh();
      }
    }

    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "#$idPesanan",
                  style: AStyle.textStyleTitleMd,
                ),
                Text(
                  transactionStatus?.status ?? "diproses",
                  style: AStyle.textStyleNormal.copyWith(
                      color: TW3Colors.orange.shade600,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
            ...detailPesanan.map((pesanan) => AtmaTransactionCard(
                nama: pesanan.namaProduk,
                ukuran: pesanan.produk?.ukuran ?? "",
                thumbnail: pesanan.produk?.thumbnail?.image ??
                    pesanan.hampers?.image ??
                    "https://www.posindonesia.co.id/_next/image?url=https%3A%2F%2Fadmin-piol.posindonesia.co.id%2Fmedia%2Fimage-not-found-placeholder.png&w=3840&q=75",
                jumlah: pesanan.jumlah,
                harga: pesanan.harga)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Pesanan",
                  style: TextStyle(color: TW3Colors.slate.shade400),
                ),
                Text(
                  CurrencyFormat.convertToIdr(total, 0),
                  style: AStyle.textStyleTitleMd.copyWith(
                      color: TW3Colors.orange.shade600,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            if (transactionStatus!.status == "Sedang dikirim kurir" ||
                transactionStatus!.status == "Sudah dipickup")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8.0,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: AtmaButton(
                      textButton: "Terima Pesanan",
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => Dialog(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                    'Apakah anda yakin bahwa barang telah diterima?'),
                                const SizedBox(height: 15),
                                TextButton(
                                  onPressed: () {
                                    onUpdateHandler();

                                    Navigator.pop(context);
                                  },
                                  child: const Text('Terima Pesanan'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      btnWidth: 152.0,
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}

class AtmaTransactionCard extends StatelessWidget {
  final String thumbnail;
  final String nama;
  final String ukuran;
  final int jumlah;
  final int harga;
  final int? total;
  const AtmaTransactionCard(
      {Key? key,
      required this.nama,
      required this.ukuran,
      required this.thumbnail,
      required this.jumlah,
      required this.harga,
      this.total = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Image.network(
              thumbnail,
              width: 64.0,
              height: 64.0,
            ),
            const SizedBox(
              width: 8.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$nama $ukuran"),
                Text(
                    "$jumlah produk x  ${CurrencyFormat.convertToIdr(harga, 0)}",
                    style: TextStyle(
                        color: TW3Colors.slate.shade400,
                        fontWeight: FontWeight.w400))
              ],
            )
          ],
        ),
        const Divider(
          height: 0,
          thickness: 0.5,
        ),
        const SizedBox(
          height: 8.0,
        ),
      ],
    );
  }
}
