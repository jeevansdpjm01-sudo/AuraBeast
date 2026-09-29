import 'package:flutter/material.dart';

class AlbumCard extends StatelessWidget {
  final String title;
  final String artist;
  final String artworkUrl;
  final String releaseYear;
  final int trackCount;
  final VoidCallback onTap;

  const AlbumCard({
    super.key,
    required this.title,
    required this.artist,
    required this.artworkUrl,
    this.releaseYear = '',
    this.trackCount = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1F2D),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            const BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              blurRadius: 16,
              spreadRadius: 1,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildArtwork(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (releaseYear.isNotEmpty) ...[
                        const Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.white38,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          releaseYear,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white38,
                          ),
                        ),
                      ],
                      if (releaseYear.isNotEmpty && trackCount > 0)
                        const SizedBox(width: 16),
                      if (trackCount > 0) ...[
                        const Icon(
                          Icons.library_music,
                          size: 14,
                          color: Colors.white38,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$trackCount tracks',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white38,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.white54,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtwork() {
    if (artworkUrl.isEmpty) {
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade900,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(
          Icons.album,
          size: 36,
          color: Colors.white,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: artworkUrl.startsWith('assets/')
          ? Image.asset(
              artworkUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade900,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.album,
                    size: 36,
                    color: Colors.white,
                  ),
                );
              },
            )
          : Image.network(
              artworkUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade900,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.album,
                    size: 36,
                    color: Colors.white,
                  ),
                );
              },
            ),
    );
  }
}
