import 'package:flutter/material.dart';

enum CoverType { asset, network }

class PlaylistCard extends StatelessWidget {
  final String name;
  final String description;
  final String coverUrl;
  final CoverType coverType;
  final int songCount;
  final Duration duration;
  final VoidCallback onTap;

  const PlaylistCard({
    super.key,
    required this.name,
    required this.description,
    this.coverUrl = '',
    this.coverType = CoverType.network,
    this.songCount = 0,
    this.duration = Duration.zero,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
            _buildCover(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Flexible(
                        child: _buildInfoChip(
                          icon: Icons.music_note,
                          label: '$songCount songs',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: _buildInfoChip(
                          icon: Icons.access_time,
                          label: _formatDuration(duration),
                        ),
                      ),
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

  Widget _buildFallbackCover() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade900,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Icon(
        Icons.playlist_play,
        size: 36,
        color: Colors.white,
      ),
    );
  }

  Widget _buildCover() {
    if (coverUrl.isEmpty) {
      return _buildFallbackCover();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: coverType == CoverType.asset
          ? Image.asset(
              coverUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildFallbackCover(),
            )
          : Image.network(
              coverUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade900.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => _buildFallbackCover(),
            ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2B3D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Colors.deepPurpleAccent,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final String minutes = duration.inMinutes.toString().padLeft(2, '0');
    final String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
