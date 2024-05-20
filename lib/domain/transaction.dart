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
  TransactionStatus? statusPesananLatest;
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
      this.statusPesananLatest,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      idPesanan: json['id_pesanan'].toString(),
      idMetodePembayaran: json['id_metode_pembayaran'] as int,
      idPelanggan: json['id_pelanggan'] as int,
      tglOrder: json['tgl_order'].toString(),
      totalDiskonPoin: json['total_diskon_poin'] as int,
      totalPesanan: json['total_pesanan'] as int,
      totalSetelahDiskon: json['total_setelah_diskon'] as int,
      totalDibayarkan: json['total_dibayarkan'] as int?,
      totalTip: json['total_tip'] as int?,
      jenisPengiriman: json['jenis_pengiriman'].toString(),
      buktiPembayaran: json['bukti_pembayaran']?.toString(),
      verifiedAt: json['verified_at']?.toString(),
      acceptedAt: json['accepted_at']?.toString(),
      detailPesanan: (json['detail_pesanan'] as List<dynamic>?)
          ?.map((detail) => DetailTransaction.fromJson(detail))
          .toList(),
      statusPesananLatest: json['status_pesanan_latest'] != null
          ? TransactionStatus.fromJson(json['status_pesanan_latest'])
          : null,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      deletedAt: json['deleted_at']?.toString(),
    );
  }
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

class TransactionStatus {
  final int idStatusPesanan;
  final String? idPesanan;
  final String? idKaryawan;
  final String status;
  final String? createdAt;

  TransactionStatus(
      {required this.idStatusPesanan,
      this.idPesanan,
      this.idKaryawan,
      required this.status,
      this.createdAt});

  factory TransactionStatus.fromJson(Map<String, dynamic> json) {
    return TransactionStatus(
      idStatusPesanan: json['id_status_pesanan'],
      idPesanan: json['id_pesanan'].toString(),
      idKaryawan: json['id_karyawan'].toString(),
      status: json['status'].toString(),
      createdAt: json['created_at'].toString(),
    );
  }
}
