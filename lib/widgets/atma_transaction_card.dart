import 'package:atmakitchen_mobile/utils/utils.dart';
import 'package:flutter/widgets.dart';

class AtmaTransactionCard extends StatelessWidget {
  final String thumbnail;
  final String nama;
  final String ukuran;
  final int jumlah;
  final int harga;
  final int total;
  const AtmaTransactionCard(
      {Key? key,
      required this.nama,
      required this.ukuran,
      required this.thumbnail,
      required this.jumlah,
      required this.harga,
      required this.total})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Image.network(thumbnail),
            const SizedBox(
              width: 8.0,
            ),
            Text("$nama $ukuran")
          ],
        ),
        const SizedBox(
          height: 8.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("$jumlah produk"),
            Text("Total Pesanan: ${CurrencyFormat.convertToIdr(total, 0)}"),
          ],
        )
      ],
    );
  }
}
