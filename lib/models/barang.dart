class Barang {
  String id;
  String namaBarang;
  int jmlBarang;
  int hargaBarang;
  DateTime? createdAt; // Keep it as DateTime
  DateTime updatedAt;

  Barang({
    required this.id,
    required this.namaBarang,
    required this.jmlBarang,
    required this.hargaBarang,
    this.createdAt,
    required this.updatedAt,
  });

  factory Barang.fromJson(Map<String, dynamic> json) => Barang(
        id: json['id'].toString(),
        namaBarang: json['nama_barang'],
        jmlBarang: json['jml_barang'],
        hargaBarang: json['harga_barang'],
        // if the value is null, then return null
        createdAt: DateTime.parse(json['created_at'] ?? DateTime.now()),
        updatedAt: DateTime.parse(json['updated_at']),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nama_barang'] = namaBarang;
    data['jml_barang'] = jmlBarang;
    data['harga_barang'] = hargaBarang;
    data['created_at'] =
        createdAt?.toIso8601String(); // Convert DateTime to String
    data['updated_at'] =
        updatedAt.toIso8601String(); // Convert DateTime to String

    return data;
  }
}
