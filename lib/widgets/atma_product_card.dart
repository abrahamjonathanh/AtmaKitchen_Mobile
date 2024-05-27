import 'package:atmakitchen_mobile/constants/styles.dart';
import 'package:atmakitchen_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:tailwind_colors/tailwind_colors.dart';

class AtmaProductCard extends StatelessWidget {
  final String? nama;
  final String? ukuran;
  final int? hargaJual;

  const AtmaProductCard(
      {Key? key,
      this.nama = "Lapis Legit",
      this.ukuran = "20x20 cm",
      this.hargaJual = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
              "https://atmaimages.blob.core.windows.net/images/Lapis legit.png"),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$nama $ukuran",
                  style: AStyle.textStyleTitleMd
                      .copyWith(fontWeight: FontWeight.w400),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  CurrencyFormat.convertToIdr(hargaJual!, 0),
                  style: AStyle.textStyleTitleMd.copyWith(
                      color: TW3Colors.orange.shade600,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
