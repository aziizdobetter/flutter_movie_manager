import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/media_model.dart';
import 'database_helper.dart';

class FileService {
  // EXPORT DATA KE JSON (DI ANDROID/DATA/PACKAGE_NAME/FILES/)
  Future<String> exportToJson() async {
    try {
      // 1. Ambil data dari SQLite (Async)
      final List<MediaModel> mediaList = await DatabaseHelper().getAllMedia();

      // 2. Konversi list ke format JSON string
      final List<Map<String, dynamic>> jsonData = mediaList
          .map((e) => e.toJson())
          .toList();
      final String jsonString = const JsonEncoder.withIndent('  ')
          .convert(jsonData);

      // 3. Tentukan direktori penyimpanan eksternal (Async)
      // Di Android, path_provider mengembalikan:
      // /storage/emulated/0/Android/data/<package_name>/files/
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else {
        // Fallback untuk iOS/desktop agar tetap berjalan
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        throw Exception('Direktori penyimpanan tidak tersedia');
      }

      // 4. Buat subfolder 'KoleksiMovies' (opsional, agar rapi)
      // final subFolder = Directory('${directory.path}/KoleksiMovies');
      final subFolder = Directory(directory.path);
      if (!await subFolder.exists()) {
        await subFolder.create(recursive: true);
      }

      // 5. Buat file dan tulis data
      final file = File('${subFolder.path}/backup_koleksi_media.json');
      await file.writeAsString(jsonString);

      return file.path;
    } catch (e) {
      throw Exception('Gagal export data: $e');
    }
  }

  // IMPORT DATA DARI JSON (tidak berubah)
  Future<int> importFromJson(File file) async {
    try {
      final String jsonString = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(jsonString);
      final List<MediaModel> mediaList = jsonData
          .map(
            (e) => MediaModel(
              judul: e['judul'],
              rating: (e['rating'] as num).toDouble(),
              kategori: e['kategori'],
            ),
          )
          .toList();

      await DatabaseHelper().clearAllMedia();

      int count = 0;
      for (var media in mediaList) {
        await DatabaseHelper().insertMedia(media);
        count++;
      }

      return count;
    } catch (e) {
      throw Exception(
        'Gagal import data: Format JSON tidak valid atau error sistem.',
      );
    }
  }
}
