class MediaModel {
  final int? id;
  final String judul;
  final double rating;
  final String kategori; // 'Movie' atau 'Series'

  MediaModel({
    this.id,
    required this.judul,
    required this.rating,
    required this.kategori,
  });

  // Konversi ke Map untuk SQLite
  Map<String, dynamic> toMap() {
    return {'id': id, 'judul': judul, 'rating': rating, 'kategori': kategori};
  }

  // Konversi dari Map SQLite ke Object
  factory MediaModel.fromMap(Map<String, dynamic> map) {
    return MediaModel(
      id: map['id'],
      judul: map['judul'],
      rating: map['rating'].toDouble(),
      kategori: map['kategori'],
    );
  }

  // Konversi ke Map untuk Export JSON (tanpa ID agar saat import tidak bentrok)
  Map<String, dynamic> toJson() {
    return {'judul': judul, 'rating': rating, 'kategori': kategori};
  }
}
