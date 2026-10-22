import 'package:flutter/material.dart';

import '../models/media_model.dart';
import '../services/database_helper.dart';
import '../theme.dart';

class FormPage extends StatefulWidget {
  final MediaModel? media; // Null = Tambah, Not Null = Edit
  const FormPage({super.key, this.media});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();

  double _rating = 5.0;
  String _kategori = 'Movie';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Jika mode Edit, isi form dengan data yang ada
    if (widget.media != null) {
      _judulController.text = widget.media!.judul;
      _rating = widget.media!.rating;
      _kategori = widget.media!.kategori;
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    super.dispose();
  }

  // FUNGSI ASINKRON: Simpan/Update ke SQLite
  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final newMedia = MediaModel(
      id: widget.media?.id, // Tetap gunakan ID jika mode edit
      judul: _judulController.text.trim(),
      rating: _rating,
      kategori: _kategori,
    );

    try {
      if (widget.media == null) {
        await DatabaseHelper().insertMedia(newMedia); // CREATE
      } else {
        await DatabaseHelper().updateMedia(newMedia); // UPDATE
      }

      if (mounted) {
        Navigator.pop(context, true); // Kembali ke Home dengan sinyal sukses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.media == null
                  ? 'Koleksi ditambahkan!'
                  : 'Koleksi diperbarui!',
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
            content: Text('Gagal menyimpan: $e'),
            backgroundColor: AppTheme.merah,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.media != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Koleksi' : 'Tambah Koleksi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // INPUT JUDUL
              const Text(
                'Judul',
                style: TextStyle(
                  color: AppTheme.putihTulang,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _judulController,
                style: const TextStyle(color: AppTheme.putihTulang),
                decoration: InputDecoration(
                  hintText: 'Masukkan judul movie/series',
                  hintStyle: const TextStyle(color: AppTheme.abuAbu),
                  filled: true,
                  fillColor: AppTheme.hitam,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppTheme.abuAbu,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppTheme.merah,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppTheme.merah,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // INPUT KATEGORI
              const Text(
                'Kategori',
                style: TextStyle(
                  color: AppTheme.putihTulang,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppTheme.hitam,
                  border: Border.all(color: AppTheme.abuAbu, width: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _kategori,
                    isExpanded: true,
                    dropdownColor: AppTheme.hitam,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: AppTheme.abuAbu,
                    ),
                    style: const TextStyle(color: AppTheme.putihTulang),
                    items: ['Movie', 'Series'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() => _kategori = newValue!);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // INPUT RATING
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Rating',
                    style: TextStyle(
                      color: AppTheme.putihTulang,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _rating.toStringAsFixed(1),
                    style: const TextStyle(
                      color: AppTheme.merah,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Slider(
                value: _rating,
                min: 1.0,
                max: 10.0,
                divisions: 18, // 0.5 step (10 - 1) / 0.5 = 18
                activeColor: AppTheme.merah,
                inactiveColor: AppTheme.abuAbu,
                label: _rating.toStringAsFixed(1),
                onChanged: (value) {
                  setState(() => _rating = value);
                },
              ),
              const SizedBox(height: 32),

              // TOMBOL SIMPAN
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveData,
                  child: _isSaving
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: AppTheme.putihTulang,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(isEdit ? 'Simpan Perubahan' : 'Tambah ke Koleksi'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
