import 'dart:convert';

class Account {
  int idAkun;
  String email;
  String? password;
  int idRole;
  Role? role;
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
      this.role,
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
        "role": Role.fromJson(role as Map<String, dynamic>),
        "profile_image": profileImage,
        "email_verified_at": emailVerifiedAt,
        "remember_token": rememberToken,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt
      };

  String toRawJson() => json.encode(toJson());

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      idAkun: json['id_akun'] as int,
      email: json['email'].toString(),
      idRole: json['id_role'] as int,
      role: Role.fromJson(json['role']),
      profileImage: json['profile_image'].toString(),
      createdAt: json['created_at'].toString(),
      updatedAt: json['updated_at'].toString(),
      deletedAt: json['deleted_at'].toString(),
    );
  }
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

class Employee {
  int idKaryawan;
  int? idAkun;
  String nama;
  int? gajiHarian;
  int? bonus;
  String? alamat;
  String? telepon;
  Account? akun;
  bool? presensi;
  int? idPresensi;

  Employee(
      {required this.idKaryawan,
      this.idAkun,
      required this.nama,
      this.gajiHarian,
      this.bonus,
      this.alamat,
      this.telepon,
      this.akun,
      this.presensi,
      this.idPresensi});
}

class Role {
  int idRole;
  String role;

  Role({required this.idRole, required this.role});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
        idRole: int.parse(json['id_role'].toString()), role: json['role']);
  }
}
