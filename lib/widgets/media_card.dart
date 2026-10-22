import 'package:flutter/material.dart';

import '../models/media_model.dart';
import '../theme.dart';

class MediaCard extends StatelessWidget {
  final MediaModel media;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const MediaCard({
    super.key,
    required this.media,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Indikator Kategori (Merah untuk Movie, Abu-abu untuk Series)
              Container(
                width: 4,
                height: 50,
                decoration: BoxDecoration(
                  color: media.kategori == 'Movie'
                      ? AppTheme.merah
                      : AppTheme.abuAbu,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),

              // Info Judul & Kategori
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      media.judul,
                      style: const TextStyle(
                        color: AppTheme.putihTulang,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      media.kategori,
                      style: const TextStyle(
                        color: AppTheme.abuAbu,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Rating dengan Ikon Bintang
              Row(
                children: [
                  const Icon(Icons.star, color: AppTheme.merah, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    media.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      color: AppTheme.putihTulang,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),

              // Tombol Hapus
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppTheme.abuAbu),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
