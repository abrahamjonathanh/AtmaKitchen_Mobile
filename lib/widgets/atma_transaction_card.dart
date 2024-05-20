import 'package:atmakitchen_mobile/constants/styles.dart';
import 'package:atmakitchen_mobile/domain/transaction.dart';
import 'package:atmakitchen_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:tailwind_colors/tailwind_colors.dart';

class AtmaTransactions extends StatelessWidget {
  final String idPesanan;
  final int total;
  final List<DetailTransaction> detailPesanan;
  final TransactionStatus? transactionStatus;

  const AtmaTransactions(
      {Key? key,
      required this.idPesanan,
      required this.total,
      required this.detailPesanan,
      this.transactionStatus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                ukuran: pesanan.produk!.ukuran,
                thumbnail: pesanan.produk!.thumbnail!.image,
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
