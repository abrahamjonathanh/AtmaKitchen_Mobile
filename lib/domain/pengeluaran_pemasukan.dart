class PengeluaranPemasukan {
  List<Map<String, int>>? pemasukan;
  List<Map<String, int>>? pengeluaran;
  int totalPemasukan;
  int totalPengeluaran;

  PengeluaranPemasukan({
    this.pemasukan,
    this.pengeluaran,
    required this.totalPemasukan,
    required this.totalPengeluaran,
  });

  factory PengeluaranPemasukan.fromJson(Map<String, dynamic> json) {
    List<Map<String, int>>? pemasukan;
    if (json['pemasukkan'] is List && (json['pemasukkan'] as List).isEmpty) {
      pemasukan = [];
    } else if (json['pemasukkan'] != null) {
      pemasukan = (json['pemasukkan'] as Map<String, dynamic>?)
          ?.entries
          .map((e) => {e.key: (e.value as num).toInt()})
          .toList();
    }

    List<Map<String, int>>? pengeluaran;
    if (json['pengeluaran'] is List && (json['pengeluaran'] as List).isEmpty) {
      pengeluaran = [];
    } else if (json['pengeluaran'] != null) {
      pengeluaran = (json['pengeluaran'] as Map<String, dynamic>?)
          ?.entries
          .map((e) => {e.key: (e.value as num).toInt()})
          .toList();
    }

    int totalPemasukan = (json['total_pemasukkan'] as num).toInt();
    int totalPengeluaran = (json['total_pengeluaran'] as num).toInt();

    return PengeluaranPemasukan(
      pemasukan: pemasukan,
      pengeluaran: pengeluaran,
      totalPemasukan: totalPemasukan,
      totalPengeluaran: totalPengeluaran,
    );
  }
}
