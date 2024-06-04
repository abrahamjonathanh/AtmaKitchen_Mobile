class BahanBaku {
  String? idBahanBaku;
  String nama;
  String satuan;
  int? stok;
  int? stokMinimum;
  int? totalUsed;

  BahanBaku(
      {this.idBahanBaku,
      required this.nama,
      required this.satuan,
      this.stok,
      this.stokMinimum,
      this.totalUsed});

  factory BahanBaku.fromJson(Map<String, dynamic> json) {
    return BahanBaku(
      idBahanBaku: json['id_bahan_baku']?.toString(),
      nama: json['nama'].toString(),
      satuan: json['satuan'].toString(),
      stok: json['stok'] as int?,
      stokMinimum: json['stok_minumum'] as int?,
      totalUsed: json['total'] as int?,
    );
  }
}
