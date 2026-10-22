import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; // Perlu tambah package

import '../models/media_model.dart';
import '../services/database_helper.dart';
import '../services/file_service.dart';
import '../theme.dart';
import '../widgets/media_card.dart';
import 'form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MediaModel> _mediaList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // FUNGSI ASINKRON: Membaca data dari SQLite
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper().getAllMedia();
    setState(() {
      _mediaList = data;
      _isLoading = false;
    });
  }

  // FUNGSI ASINKRON: Export ke JSON
  Future<void> _exportData() async {
    try {
      setState(() => _isLoading = true);
      final path = await FileService().exportToJson();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Berhasil export ke:\n$path',
              style: TextStyle(color: AppTheme.putihTulang),
            ),
            backgroundColor: AppTheme.merah,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppTheme.merah,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // FUNGSI ASINKRON: Import dari JSON
  Future<void> _importData() async {
    try {
      List<PlatformFile> result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result.isNotEmpty) {
        setState(() => _isLoading = true);
        File file = File(result.single.path!);
        int count = await FileService().importFromJson(file);
        await _loadData(); // Refresh list
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Berhasil import $count data',
                style: TextStyle(color: AppTheme.putihTulang),
              ),
              backgroundColor: AppTheme.merah,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppTheme.merah,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Konfirmasi Hapus
  Future<void> _confirmDelete(MediaModel media) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.hitam,
        title: const Text(
          'Hapus Koleksi?',
          style: TextStyle(color: AppTheme.putihTulang),
        ),
        content: Text(
          'Yakin ingin menghapus "${media.judul}"?',
          style: const TextStyle(color: AppTheme.abuAbu),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Batal',
              style: TextStyle(color: AppTheme.abuAbu),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: AppTheme.merah)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      await DatabaseHelper().deleteMedia(media.id!);
      await _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Koleksi Movies & Series'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            tooltip: 'Export JSON',
            onPressed: _exportData,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Import JSON',
            onPressed: _importData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.merah),
            )
          : _mediaList.isEmpty
          ? const Center(
              child: Text(
                'Belum ada koleksi.\nTekan + untuk menambahkan.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.abuAbu, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _mediaList.length,
              itemBuilder: (context, index) {
                final media = _mediaList[index];
                return MediaCard(
                  media: media,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => FormPage(media: media)),
                    );
                    _loadData();
                  },
                  onDelete: () => _confirmDelete(media),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormPage()),
          );
          _loadData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
