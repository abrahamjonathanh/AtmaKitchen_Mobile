class TransaksiPenitip {
  String idPenitip;
  String namaPenitip;
  int bulan;
  int tahun;
  String tanggalCetak;
  List<Transaksi> transaksi;

  TransaksiPenitip({
    required this.idPenitip,
    required this.namaPenitip,
    required this.bulan,
    required this.tahun,
    required this.tanggalCetak,
    required this.transaksi,
  });

  factory TransaksiPenitip.fromJson(Map<String, dynamic> json) {
    List<Transaksi> transaksiList = [];
    if (json['transaksi'] != null) {
      json['transaksi'].forEach((transaksi) {
        transaksiList.add(Transaksi.fromJson(transaksi));
      });
    }

    return TransaksiPenitip(
      idPenitip: json['id_penitip'],
      namaPenitip: json['nama_penitip'],
      bulan: int.parse(json['bulan']),
      tahun: int.parse(json['tahun']),
      tanggalCetak: json['tanggal_cetak'],
      transaksi: transaksiList,
    );
  }
}

class Transaksi {
  String namaProduk;
  int qty;
  int hargaJual;
  int total;
  int komisi;
  int yangDiterima;

  Transaksi({
    required this.namaProduk,
    required this.qty,
    required this.hargaJual,
    required this.total,
    required this.komisi,
    required this.yangDiterima,
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      namaProduk: json['nama_produk'],
      qty: json['qty'],
      hargaJual: json['harga_jual'],
      total: json['total'],
      komisi: json['komisi'],
      yangDiterima: json['yang_diterima'],
    );
  }
}
