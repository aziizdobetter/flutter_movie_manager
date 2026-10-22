# 🎬 Koleksi Movies & Series

Aplikasi mobile berbasis **Flutter** untuk mencatat koleksi film (Movie) dan serial (Series) beserta rating pribadi. Data tersimpan di perangkat sehingga dapat digunakan **tanpa koneksi internet**, dan dapat dicadangkan atau dipulihkan melalui berkas JSON.

Proyek ini dibuat sebagai tugas Ujian Tengah Semester (UTS) mata kuliah **Pemrograman Multiplatform**.

## 📸 Tampilan Aplikasi

<!-- Ganti path gambar berikut dengan screenshot Anda, misalnya simpan di folder screenshots/ -->
| Halaman Utama | Tambah Koleksi | Ubah Koleksi |
|:---:|:---:|:---:|
| ![Home](screenshots/home.png) | ![Tambah](screenshots/add.png) | ![Ubah](screenshots/edit.png) |

## ✨ Fitur Utama

- **Tambah koleksi**: isi judul, pilih kategori (Movie/Series), dan atur rating 1,0 – 10,0 (kelipatan 0,5).
- **Daftar koleksi**: ditampilkan dalam kartu, data terbaru berada di paling atas.
- **Ubah koleksi**: ketuk kartu untuk mengedit data.
- **Hapus koleksi**: disertai dialog konfirmasi.
- **Validasi input**: judul tidak boleh kosong.
- **Ekspor ke JSON**: cadangkan seluruh koleksi ke berkas `backup_koleksi_media.json`.
- **Impor dari JSON**: pulihkan koleksi dari berkas cadangan (data yang ada akan **diganti** dengan isi berkas).
- **Indikator proses**: indikator loading dan tombol nonaktif selama proses berjalan.
- **Tema gelap** dengan palet warna hitam, putih tulang, abu-abu, dan merah.

## 🧩 Konsep yang Diterapkan

### Asynchronous Programming
Seluruh proses yang membutuhkan waktu memakai `Future`, `async`, dan `await`, yaitu akses SQLite, baca/tulis berkas, pemilihan berkas, dialog konfirmasi, dan navigasi antarhalaman. Status proses ditangani dengan `try-catch-finally` serta variabel `_isLoading` dan `_isSaving`.

### Data Persistence
| Teknik | Kegunaan |
|---|---|
| **SQLite** (`sqflite`) | Penyimpanan utama data koleksi (operasi CRUD) |
| **Read and Write Files** (`dart:io`) | Ekspor dan impor cadangan data dalam format JSON |

## 🛠️ Teknologi dan Package

- [Flutter](https://flutter.dev/) dan [Dart](https://dart.dev/)
- [`sqflite`](https://pub.dev/packages/sqflite): basis data SQLite lokal
- [`path`](https://pub.dev/packages/path): penyusunan jalur berkas
- [`path_provider`](https://pub.dev/packages/path_provider): lokasi direktori penyimpanan
- [`file_picker`](https://pub.dev/packages/file_picker): memilih berkas JSON saat impor
- Library bawaan: `dart:io`, `dart:convert`

## 📁 Struktur Folder

```
lib/
├── main.dart                  # Titik masuk aplikasi
├── theme.dart                 # Tema dan palet warna
├── models/
│   └── media_model.dart       # Model data MediaModel
├── pages/
│   ├── home_page.dart         # Daftar koleksi, ekspor, impor
│   └── form_page.dart         # Form tambah / ubah koleksi
├── services/
│   ├── database_helper.dart   # Operasi SQLite (CRUD)
│   └── file_service.dart      # Operasi baca/tulis berkas JSON
└── widgets/
    └── media_card.dart        # Kartu item koleksi
```

## 🚀 Cara Menjalankan

### Prasyarat
- [Flutter SDK](https://docs.flutter.dev/get-started/install) sudah terpasang (cek dengan `flutter doctor`)
- Emulator Android atau perangkat fisik

### Langkah

```bash
# 1. Clone repositori
git clone https://github.com/<username>/<nama-repositori>.git
cd <nama-repositori>

# 2. Unduh dependensi
flutter pub get

# 3. Jalankan aplikasi
flutter run
```

## 💾 Format Berkas Cadangan

Berkas hasil ekspor berupa larik JSON tanpa `id`:

```json
[
  {
    "judul": "Inception",
    "rating": 9.0,
    "kategori": "Movie"
  },
  {
    "judul": "Breaking Bad",
    "rating": 9.5,
    "kategori": "Series"
  }
]
```

Di Android, berkas ekspor disimpan pada:
`/storage/emulated/0/Android/data/<package_name>/files/backup_koleksi_media.json`
(lokasi lengkap juga ditampilkan pada notifikasi setelah ekspor berhasil).
