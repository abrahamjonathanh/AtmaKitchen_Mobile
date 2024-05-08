import 'package:atmakitchen_mobile/domain/product.dart';

class Transaction {
  String idPesanan;
  int idMetodePembayaran;
  int idPelanggan;
  String tglOrder;
  int totalDiskonPoin;
  int totalPesanan;
  int totalSetelahDiskon;
  int? totalDibayarkan;
  int? totalTip;
  String jenisPengiriman;
  String? buktiPembayaran;
  String? verifiedAt;
  String? acceptedAt;
  List<DetailTransaction>? detailPesanan;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Transaction(
      {required this.idPesanan,
      required this.idMetodePembayaran,
      required this.idPelanggan,
      required this.tglOrder,
      required this.totalDiskonPoin,
      required this.totalPesanan,
      required this.totalSetelahDiskon,
      this.totalDibayarkan,
      this.totalTip,
      required this.jenisPengiriman,
      this.buktiPembayaran,
      this.verifiedAt,
      this.acceptedAt,
      this.detailPesanan,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});
}

class DetailTransaction {
  String idDetailPesanan;
  String? idPesanan;
  int? idProduk;
  int? idProdukHampers;
  String kategori;
  String namaProduk;
  int harga;
  int jumlah;
  Product? produk;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  DetailTransaction(
      {required this.idDetailPesanan,
      this.idPesanan,
      this.idProduk,
      this.idProdukHampers,
      required this.kategori,
      required this.namaProduk,
      required this.harga,
      required this.jumlah,
      this.produk,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  factory DetailTransaction.fromJson(Map<String, dynamic> json) {
    return DetailTransaction(
      idDetailPesanan: json['id_detail_pesanan'].toString(),
      idPesanan: json['id_pesanan'].toString(),
      idProduk: json['id_produk'] as int?,
      idProdukHampers: json['id_produk_hampers'] as int?,
      kategori: json['kategori'].toString(),
      namaProduk: json['nama_produk'].toString(),
      harga: json['harga'] as int,
      jumlah: json['jumlah'] as int,
      createdAt: json['created_at'].toString(),
      updatedAt: json['updated_at'].toString(),
      deletedAt: json['deleted_at'].toString(),
      produk: json['produk'] != null ? Product.fromJson(json['produk']) : null,
    );
  }
}
