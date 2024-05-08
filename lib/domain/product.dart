class Product {
  int idProduk;
  int idKategori;
  int? idPenitip;
  String nama;
  int kapasitas;
  String ukuran;
  int hargaJual;
  ProductThumbnail? thumbnail;

  Product(
      {required this.idProduk,
      required this.idKategori,
      this.idPenitip,
      required this.nama,
      required this.kapasitas,
      required this.ukuran,
      required this.hargaJual,
      this.thumbnail});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      idProduk: json['id_produk'] as int,
      idKategori: json['id_kategori'] as int,
      // idPenitip: json['id_penitip'] as int?, // ERR: [ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: type 'String' is not a subtype of type 'int?' in type cast
      nama: json['nama'].toString(),
      kapasitas: json['kapasitas'] as int,
      ukuran: json['ukuran'].toString(),
      hargaJual: json['harga_jual'] as int,
      thumbnail: ProductThumbnail.fromJson(json['thumbnail']),
    );
  }
}

class ProductThumbnail {
  int idProdukImage;
  int idProduk;
  String image;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  ProductThumbnail(
      {required this.idProdukImage,
      required this.idProduk,
      required this.image,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  factory ProductThumbnail.fromJson(Map<String, dynamic> json) {
    return ProductThumbnail(
      idProdukImage: json['id_produk_image'] as int,
      idProduk: json['id_produk'] as int,
      image: json['image'].toString(),
      createdAt: json['created_at'].toString(),
      updatedAt: json['updated_at'].toString(),
      deletedAt: json['deleted_at'].toString(),
    );
  }
}
