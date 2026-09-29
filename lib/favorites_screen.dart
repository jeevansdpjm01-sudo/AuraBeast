import 'package:flutter/material.dart';
import 'song.dart';
import 'song_card.dart';
import 'playlist_card.dart';
import 'audio_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final List<Song> likedSongs = Song.sampleSongs;

  final List<Map<String, dynamic>> playlists = [
    {
      'name': 'Liked Songs',
      'description': 'Your personal favorites in one place',
      'coverUrl': 'assets/images/cover1.jpg',
      'songCount': 32,
      'duration': const Duration(hours: 2, minutes: 5),
    },
    {
      'name': 'Weekly Mix',
      'description': 'Fresh songs picked for you',
      'coverUrl': 'assets/images/cover2.jpg',
      'songCount': 20,
      'duration': const Duration(hours: 1, minutes: 25),
    },
  ];

  String _formatDuration(Duration duration) {
    final mm = duration.inMinutes.toString().padLeft(2, '0');
    final ss = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Library'),
        backgroundColor: Colors.deepPurple.shade900,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                'Your Library',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...playlists.map((playlist) {
              return PlaylistCard(
                name: playlist['name'],
                description: playlist['description'],
                coverUrl: playlist['coverUrl'],
                songCount: playlist['songCount'],
                duration: playlist['duration'],
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Opened ${playlist['name']}')),
                  );
                },
              );
            }),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                'Liked Songs',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ...likedSongs.map((song) {
              return SongCard(
                title: song.title,
                artist: song.artist,
                duration: _formatDuration(song.duration),
                artworkUrl: song.artwork,
                isPlaying: false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SongDetailScreen(song: song),
                    ),
                  );
                },
                onPlayPause: () {
                  audioService.playAsset(
                    asset: song.audioAsset,
                    title: song.title,
                    artist: song.artist,
                    artwork: song.artwork,
                  );
                },
              );
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
