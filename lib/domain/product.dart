class Product {
  int idProduk;
  int idKategori;
  int? idPenitip;
  String nama;
  int kapasitas;
  String ukuran;
  int hargaJual;
  ProductThumbnail? thumbnail;
  int readyStock;

  Product(
      {required this.idProduk,
      required this.idKategori,
      this.idPenitip,
      required this.nama,
      required this.kapasitas,
      required this.ukuran,
      required this.hargaJual,
      this.thumbnail,
      required this.readyStock});

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
      readyStock: json['ready_stock'] as int,
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

class Hampers {
  int idProdukHampers;
  String nama;
  int hargaJual;
  String image;
  List<DetailHampers>? detailHampers;

  Hampers(
      {required this.idProdukHampers,
      required this.nama,
      required this.hargaJual,
      required this.image,
      this.detailHampers});

  factory Hampers.fromJson(Map<String, dynamic> json) {
    return Hampers(
        idProdukHampers: json['id_produk_hampers'] as int,
        nama: json['nama'].toString(),
        hargaJual: json['harga_jual'] as int,
        image: json['image'].toString(),
        detailHampers: (json['detail_hampers'] as List<dynamic>?)
            ?.map((detail) => DetailHampers.fromJson(detail))
            .toList());
  }
}

class DetailHampers {
  int idDetailHampers;
  int? idProdukHampers;
  int? idProduk;
  Product? produk;

  DetailHampers(
      {required this.idDetailHampers,
      this.idProdukHampers,
      this.idProduk,
      this.produk});

  factory DetailHampers.fromJson(Map<String, dynamic> json) {
    return DetailHampers(
        idDetailHampers: json['id_detail_hampers'] as int,
        idProdukHampers: json['id_produk_hampers'] as int,
        idProduk: json['id_produk'] as int,
        produk: Product.fromJson(json['produk']));
  }
}
