import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'l10n/app_localizations.dart';
import 'audio_service.dart';

class Song {
  final String id;
  final String title;
  final String artist;
  final Duration duration;
  final String artwork;
  final String audioAsset;
  final String source;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
    required this.artwork,
    required this.audioAsset,
    required this.source,
  });

  static final List<Song> sampleSongs = [
    Song(
      id: '1',
      title: 'Make It',
      artist: 'Aura',
      duration: const Duration(minutes: 3, seconds: 24),
      artwork: 'assets/images/cover1.jpg',
      audioAsset: 'assets/songs/makeit.wav',
      source: 'Spotify',
    ),
    Song(
      id: '2',
      title: 'Midnight Run',
      artist: 'Luna',
      duration: const Duration(minutes: 4, seconds: 2),
      artwork: 'assets/images/cover2.jpg',
      audioAsset: 'assets/songs/song2.wav',
      source: 'JioSaavn',
    ),
    Song(
      id: '3',
      title: 'Pulse',
      artist: 'Nova',
      duration: const Duration(minutes: 2, seconds: 48),
      artwork: 'assets/images/aura_image.png',
      audioAsset: 'assets/songs/song3.wav',
      source: 'Spotify',
    ),
  ];
}

class SongListScreen extends StatelessWidget {
  const SongListScreen({super.key});

  String _formatDuration(Duration d) {
    final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.songs),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.separated(
        itemCount: Song.sampleSongs.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final song = Song.sampleSongs[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            title: Text(song.title, style: const TextStyle(color: Colors.white)),
            subtitle: Text('${loc.artist}: ${song.artist}', style: const TextStyle(color: Colors.white70)),
            trailing: Text(
              _formatDuration(song.duration),
              style: const TextStyle(color: Colors.white70),
            ),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                song.artwork,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade900,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.broken_image,
                      color: Colors.white70,
                      size: 24,
                    ),
                  );
                },
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SongDetailScreen(song: song),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SongDetailScreen extends StatefulWidget {
  final Song song;

  const SongDetailScreen({super.key, required this.song});

  @override
  State<SongDetailScreen> createState() => _SongDetailScreenState();
}

class _SongDetailScreenState extends State<SongDetailScreen> {
  String _formatDuration(Duration d) {
    final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.song.title),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: const Color(0xFF121212),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                widget.song.artwork,
                width: double.infinity,
                height: 260,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 260,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade900,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.broken_image,
                      color: Colors.white70,
                      size: 48,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.song.title,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${loc.artist}: ${widget.song.artist}',
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              '${loc.duration}: ${_formatDuration(widget.song.duration)}',
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 24),
            ValueListenableBuilder<PlaybackTrack?>(
              valueListenable: audioService.currentTrack,
              builder: (context, currentTrack, _) {
                final isCurrent = currentTrack?.asset == widget.song.audioAsset;
                return StreamBuilder<PlayerState>(
                  stream: audioService.playerStateStream,
                  builder: (context, stateSnapshot) {
                    final isPlaying = isCurrent && (stateSnapshot.data?.playing ?? false);
                    return Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (isCurrent) {
                            audioService.togglePlayback();
                          } else {
                            audioService.playAsset(
                              asset: widget.song.audioAsset,
                              title: widget.song.title,
                              artist: widget.song.artist,
                              artwork: widget.song.artwork,
                            );
                          }
                        },
                        icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                        label: Text(isPlaying ? 'Pause' : loc.play),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
