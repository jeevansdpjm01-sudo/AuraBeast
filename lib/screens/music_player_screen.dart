import 'package:flutter/material.dart';
import 'package:aurabeast/services/audio_service.dart';
import 'package:aurabeast/widgets/app_bar.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final AudioService _audioService = AudioService.instance;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _audioService.init();
    if (mounted) setState(() => _isInitialized = true);
  }

  String _formatDuration(Duration d) {
    final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'Now Playing'),
      body: ValueListenableBuilder<PlaybackTrack?>(
        valueListenable: _audioService.currentTrack,
        builder: (context, currentTrack, _) {
          if (currentTrack == null) {
            return const Center(child: Text('No track selected'));
          }

          return Column(
            children: [
              // Album art
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: currentTrack.artwork != null && currentTrack.artwork!.isNotEmpty
                      ? Image.asset(
                          currentTrack.artwork!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.deepPurple.shade900,
                            child: const Icon(Icons.music_note, size: 48, color: Colors.white70),
                          ),
                        )
                      : Container(
                          color: Colors.deepPurple.shade900,
                          child: const Icon(Icons.music_note, size: 48, color: Colors.white70),
                        ),
                ),
              ),
              // Track info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  children: [
                    Text(
                      currentTrack.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentTrack.artist,
                      style: const TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              // Progress bar
              ValueListenableBuilder<Duration>(
                valueListenable: _audioService.positionStream,
                builder: (context, position, _) {
                  return Column(
                    children: [
                      Slider(
                        min: 0,
                        max: (_audioService.duration?.inMilliseconds.toDouble() ?? 0),
                        value: position.inMilliseconds.toDouble(),
                        onChanged: (value) {
                          final position = Duration(milliseconds: value.round());
                          _audioService.seek(position);
                        },
                        activeColor: Colors.deepPurple,
                        inactiveColor: Colors.white24,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_formatDuration(position), style: const TextStyle(color: Colors.white70)),
                            Text(_formatDuration(_audioService.duration ?? Duration.zero), style: const TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              // Controls
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Shuffle
                  ValueListenableBuilder<bool>(
                    valueListenable: _audioService.shuffleEnabled,
                    builder: (context, shuffleEnabled, _) {
                      return IconButton(
                        icon: Icon(
                          shuffleEnabled ? Icons.shuffle : Icons.shuffle_off,
                          color: shuffleEnabled ? Colors.deepPurple : Colors.white70,
                        ),
                        onPressed: () async {
                          await _audioService.setShuffle(!shuffleEnabled);
                        },
                      );
                    },
                  ),
                  // Previous
                  IconButton(
                    icon: const Icon(Icons.skip_previous, size: 36),
                    onPressed: () async {
                      await _audioService.skipToPrevious();
                    },
                  ),
                  // Play/Pause
                  ValueListenableBuilder<PlayerState>(
                    valueListenable: _audioService.playerStateStream,
                    builder: (context, state, _) {
                      final bool playing = state.playing;
                      return IconButton(
                        icon: Icon(
                          playing ? Icons.pause : Icons.play_arrow,
                          size: 48,
                        ),
                        onPressed: () async {
                          if (playing) {
                            await _audioService.pause();
                          } else {
                            await _audioService.play();
                          }
                        },
                      );
                    },
                  ),
                  // Next
                  IconButton(
                    icon: const Icon(Icons.skip_next, size: 36),
                    onPressed: () async {
                      await _audioService.skipToNext();
                    },
                  ),
                  // Repeat
                  ValueListenableBuilder<LoopMode>(
                    valueListenable: _audioService.repeatMode,
                    builder: (context, mode, _) {
                      IconData icon;
                      Color color;
                      switch (mode) {
                        case LoopMode.off:
                          icon = Icons.repeat;
                          color = Colors.white70;
                          break;
                        case LoopMode.one:
                          icon = Icons.repeat_one;
                          color = Colors.deepPurple;
                          break;
                        case LoopMode.all:
                          icon = Icons.repeat;
                          color = Colors.deepPurple;
                          break;
                      }
                      return IconButton(
                        icon: Icon(icon, color: color),
                        onPressed: () async {
                          LoopMode newMode;
                          switch (mode) {
                            case LoopMode.off:
                              newMode = LoopMode.one;
                              break;
                            case LoopMode.one:
                              newMode = LoopMode.all;
                              break;
                            case LoopMode.all:
                              newMode = LoopMode.off;
                              break;
                          }
                          await _audioService.setRepeat(newMode);
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}