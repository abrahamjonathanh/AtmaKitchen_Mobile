class BahanBaku {
  String idBahanBaku;
  String nama;
  String satuan;
  int stok;
  int stokMinimum;

  BahanBaku({
    required this.idBahanBaku,
    required this.nama,
    required this.satuan,
    required this.stok,
    required this.stokMinimum,
  });

  factory BahanBaku.fromJson(Map<String, dynamic> json) {
    return BahanBaku(
      idBahanBaku: json['id_bahan_baku'] as String,
      nama: json['nama'].toString(),
      satuan: json['satuan'].toString(),
      stok: json['stok'] as int,
      stokMinimum: json['stok_minumum'] as int,
    );
  }
}
