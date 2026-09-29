import 'package:flutter/material.dart';
import 'song.dart';
import 'song_card.dart';
import 'playlist_card.dart';
import 'album_card.dart';
import 'audio_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> playlists = [
    {
      'name': 'Aura Essentials',
      'description': 'The best Aura Beast tracks for your vibe',
      'coverUrl': 'assets/images/cover1.jpg',
      'songCount': 25,
      'duration': const Duration(hours: 1, minutes: 42),
    },
    {
      'name': 'Night Flight',
      'description': 'Moody beats for late-night adventures',
      'coverUrl': 'assets/images/cover2.jpg',
      'songCount': 18,
      'duration': const Duration(hours: 1, minutes: 18),
    },
    {
      'name': 'Beast Mode',
      'description': 'Power-up tracks for intense listening',
      'coverUrl': 'assets/images/aura_image.png',
      'songCount': 20,
      'duration': const Duration(hours: 1, minutes: 30),
    },
  ];

  final List<Map<String, dynamic>> albums = [
    {
      'title': 'Aura Echoes',
      'artist': 'Luna',
      'artworkUrl': 'assets/images/cover1.jpg',
      'releaseYear': '2026',
      'trackCount': 12,
    },
    {
      'title': 'Morning Lights',
      'artist': 'Echo Ray',
      'artworkUrl': 'assets/images/cover2.jpg',
      'releaseYear': '2025',
      'trackCount': 10,
    },
  ];

  

  final List<Song> recentSongs = Song.sampleSongs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10101A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good Afternoon',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'AuraBeast',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade700,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF1A1B27),
                    hintText: 'Search Aura Beast songs',
                    hintStyle: const TextStyle(color: Colors.white38),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Made for you',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: playlists.length,
                  itemBuilder: (context, index) {
                    final playlist = playlists[index];
                    return SizedBox(
                      width: 280,
                      child: PlaylistCard(
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
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'New albums',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Column(
                children: albums.map((album) {
                  return AlbumCard(
                    title: album['title'],
                    artist: album['artist'],
                    artworkUrl: album['artworkUrl'],
                    releaseYear: album['releaseYear'],
                    trackCount: album['trackCount'],
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Opened ${album['title']}')),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Recently played',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: recentSongs.map((song) {
                  return SongCard(
                    title: song.title,
                    artist: song.artist,
                    duration: '${song.duration.inMinutes}:${song.duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
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
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
