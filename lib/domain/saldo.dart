class Saldo {
  final double totalSaldo;

  Saldo({required this.totalSaldo});

  factory Saldo.fromJson(Map<String, dynamic> json) {
    return Saldo(
      totalSaldo: json['total_saldo'].toDouble(),
    );
  }
}

class PenarikanSaldo {
  final double jumlahPenarikan;
  final String status;
  final String createdAt;

  PenarikanSaldo({
    required this.jumlahPenarikan,
    required this.status,
    required this.createdAt,
  });

  factory PenarikanSaldo.fromJson(Map<String, dynamic> json) {
    return PenarikanSaldo(
      jumlahPenarikan: json['jumlah_penarikan'].toDouble(),
      status: json['status'],
      createdAt: json['created_at'],
    );
  }
}
