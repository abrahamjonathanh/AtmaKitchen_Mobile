import 'dart:convert';

class Presence {
  int? idPresensi;
  int idKaryawan;
  String? nama;
  int? jumlahAbsent;
  int? jumlahHadir;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Presence(
      {this.idPresensi,
      required this.idKaryawan,
      this.nama,
      this.jumlahAbsent,
      this.jumlahHadir,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Map<String, dynamic> toJson() => {
        "id_presensi": idPresensi,
        "id_karyawan": idKaryawan,
        "nama": nama,
        "jumlah_absent": jumlahAbsent,
        "jumlah_hadir": jumlahHadir,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt
      };

  String toRawJson() => json.encode(toJson());
}
