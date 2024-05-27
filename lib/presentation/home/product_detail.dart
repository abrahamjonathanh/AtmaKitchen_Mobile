import 'package:atmakitchen_mobile/constants/styles.dart';
import 'package:atmakitchen_mobile/domain/product.dart';
import 'package:atmakitchen_mobile/utils/utils.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product produk;
  const ProductDetailScreen({Key? key, required this.produk}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.produk.nama),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(widget.produk.thumbnail!.image),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.produk.nama,
                  style: AStyle.textStyleTitleLg,
                ),
                Text(
                  CurrencyFormat.convertToIdr(widget.produk.hargaJual, 0),
                  style: AStyle.textStyleTitleMd
                      .copyWith(fontWeight: FontWeight.normal),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ProductDetailHampersScreen extends StatefulWidget {
  final Hampers hampers;
  const ProductDetailHampersScreen({Key? key, required this.hampers})
      : super(key: key);

  @override
  State<ProductDetailHampersScreen> createState() =>
      _ProductDetailHampersScreenState();
}

class _ProductDetailHampersScreenState
    extends State<ProductDetailHampersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hampers.nama),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(widget.hampers.image),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.hampers.nama,
                  style: AStyle.textStyleTitleLg,
                ),
                Text(
                  CurrencyFormat.convertToIdr(widget.hampers.hargaJual, 0),
                  style: AStyle.textStyleTitleMd
                      .copyWith(fontWeight: FontWeight.normal),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                const Text(
                  "Deskripsi",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                    "${widget.hampers.nama} merupakan produk hampers yang terdiri dari beberapa isian."),
                ...?widget.hampers.detailHampers
                    ?.map((data) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${data.produk!.nama} ${data.produk!.ukuran}"),
                            const Text("1 buah")
                          ],
                        ))
                    .toList()
              ],
            ),
          )
        ],
      ),
    );
  }
}
