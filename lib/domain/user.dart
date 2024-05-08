import 'dart:convert';

class Account {
  int idAkun;
  String email;
  String? password;
  int idRole;
  String? profileImage;
  String? emailVerifiedAt;
  String? rememberToken;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Account(
      {required this.idAkun,
      required this.email,
      this.password,
      required this.idRole,
      this.profileImage,
      this.emailVerifiedAt,
      this.rememberToken,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Map<String, dynamic> toJson() => {
        "id_akun": idAkun,
        "email": email,
        "password": password,
        "id_role": idRole,
        "profile_image": profileImage,
        "email_verified_at": emailVerifiedAt,
        "remember_token": rememberToken,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt
      };

  String toRawJson() => json.encode(toJson());
}

class Customer {
  int idPelanggan;
  int idAkun;
  String nama;
  Account? akun;
  String? tglLahir;
  String? telepon;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Customer(
      {required this.idPelanggan,
      required this.idAkun,
      required this.nama,
      this.akun,
      this.tglLahir,
      this.telepon,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Map<String, dynamic> toJson() => {
        "id_pelanggan": idPelanggan,
        "id_akun": idAkun,
        "nama": nama,
        "akun": akun,
        "tgl_lahir": tglLahir,
        "telepon": telepon,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt
      };

  String toRawJson() => json.encode(toJson());
}

class Staff {
  int idKaryawan;
  String nama;

  Staff({required this.idKaryawan, required this.nama});
}
