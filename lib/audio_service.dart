import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

final audioService = AudioService();

class PlaybackTrack {
  final String asset;
  final String title;
  final String artist;
  final String? artwork;

  PlaybackTrack({
    required this.asset,
    required this.title,
    required this.artist,
    this.artwork,
  });
}

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ValueNotifier<PlaybackTrack?> currentTrack = ValueNotifier(null);
  final ValueNotifier<List<PlaybackTrack>> queue = ValueNotifier(const []);
  final ValueNotifier<bool> shuffleEnabled = ValueNotifier(false);
  final ValueNotifier<LoopMode> repeatMode = ValueNotifier(LoopMode.off);
  final List<PlaybackTrack> _playlist = [];

  Future<void> init() async {
    await _audioPlayer.setAudioSources([]);
    _audioPlayer.currentIndexStream.listen((index) {
      if (index != null && index < _playlist.length) {
        currentTrack.value = _playlist[index];
      }
    });
    _audioPlayer.setLoopMode(LoopMode.off);
  }

  Future<void> playAsset({
    required String asset,
    required String title,
    required String artist,
    String? artwork,
  }) async {
    final requestedTrack = PlaybackTrack(
      asset: asset,
      title: title,
      artist: artist,
      artwork: artwork,
    );

    final playlistTracks = _buildPlaylist(requestedTrack);
    final shouldReload = _playlist.length != playlistTracks.length ||
        _playlist.asMap().entries.any((entry) => entry.value.asset != playlistTracks[entry.key].asset);

    if (shouldReload) {
      _playlist
        ..clear()
        ..addAll(playlistTracks);
      queue.value = List.unmodifiable(_playlist);

      final source = ConcatenatingAudioSource(
        children: playlistTracks.map((track) => _buildSource(track)).toList(),
      );
      final initialIndex = playlistTracks.indexWhere((track) => track.asset == requestedTrack.asset);
      await _audioPlayer.setAudioSource(source, initialIndex: initialIndex >= 0 ? initialIndex : 0);
    }

    currentTrack.value = requestedTrack;
    await _audioPlayer.setShuffleModeEnabled(shuffleEnabled.value);
    await _audioPlayer.play();
  }

  Future<void> addToQueue(PlaybackTrack track, {bool playNext = false}) async {
    final updated = [..._playlist];
    if (updated.any((item) => item.asset == track.asset)) {
      if (playNext) {
        updated.removeWhere((item) => item.asset == track.asset);
      } else {
        return;
      }
    }
    final insertAt = playNext ? (_audioPlayer.currentIndex ?? 0) + 1 : updated.length;
    updated.insert(insertAt.clamp(0, updated.length), track);
    await _replacePlaylist(updated, currentIndex: _audioPlayer.currentIndex ?? 0);
  }

  Future<void> removeFromQueue(int index) async {
    if (index < 0 || index >= _playlist.length) return;
    final updated = [..._playlist]..removeAt(index);
    if (updated.isEmpty) {
      await stop();
      queue.value = const [];
      return;
    }
    await _replacePlaylist(updated, currentIndex: (_audioPlayer.currentIndex ?? 0).clamp(0, updated.length - 1));
  }

  Future<void> reorderQueue(int oldIndex, int newIndex) async {
    if (oldIndex < 0 || oldIndex >= _playlist.length) return;
    final updated = [..._playlist];
    final item = updated.removeAt(oldIndex);
    if (newIndex > oldIndex) newIndex--;
    updated.insert(newIndex.clamp(0, updated.length), item);
    await _replacePlaylist(updated, currentIndex: _audioPlayer.currentIndex ?? 0);
  }

  Future<void> clearQueue() async {
    await stop();
    _playlist.clear();
    queue.value = const [];
  }

  Future<void> setShuffle(bool enabled) async {
    shuffleEnabled.value = enabled;
    await _audioPlayer.setShuffleModeEnabled(enabled);
  }

  Future<void> setRepeat(LoopMode mode) async {
    repeatMode.value = mode;
    await _audioPlayer.setLoopMode(mode);
  }

  Future<void> setVolume(double volume) => _audioPlayer.setVolume(volume.clamp(0, 1));

  Future<void> _replacePlaylist(List<PlaybackTrack> tracks, {required int currentIndex}) async {
    final wasPlaying = _audioPlayer.playing;
    _playlist..clear()..addAll(tracks);
    queue.value = List.unmodifiable(_playlist);
    await _audioPlayer.setAudioSource(
      ConcatenatingAudioSource(children: tracks.map(_buildSource).toList()),
      initialIndex: currentIndex.clamp(0, tracks.length - 1),
    );
    if (wasPlaying) await _audioPlayer.play();
  }

  List<PlaybackTrack> _buildPlaylist(PlaybackTrack requestedTrack) {
    final fallbackTracks = <PlaybackTrack>[
      PlaybackTrack(
        asset: 'assets/songs/makeit.mp3',
        title: 'Make It',
        artist: 'Aura',
        artwork: 'assets/images/cover1.jpg',
      ),
      PlaybackTrack(
        asset: 'assets/songs/song2.mp3',
        title: 'Midnight Run',
        artist: 'Luna',
        artwork: 'assets/images/cover2.jpg',
      ),
      PlaybackTrack(
        asset: 'assets/songs/song3.mp3',
        title: 'Pulse',
        artist: 'Nova',
        artwork: 'assets/images/aura_image.png',
      ),
    ];

    final tracks = <PlaybackTrack>[requestedTrack];
    tracks.addAll(fallbackTracks.where((track) => track.asset != requestedTrack.asset));
    return tracks;
  }

  AudioSource _buildSource(PlaybackTrack track) {
    if (track.asset.startsWith('http')) {
      return AudioSource.uri(
        Uri.parse(track.asset),
        tag: MediaItem(
          id: track.asset,
          title: track.title,
          artist: track.artist,
          artUri: track.artwork != null ? Uri.parse('asset:///${track.artwork}') : null,
          album: 'AuraBeast',
        ),
      );
    }

    return AudioSource.asset(
      track.asset,
      tag: MediaItem(
        id: track.asset,
        title: track.title,
        artist: track.artist,
        artUri: track.artwork != null ? Uri.parse('asset:///${track.artwork}') : null,
        album: 'AuraBeast',
      ),
    );
  }

  Future<void> play() async {
    await _audioPlayer.play();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> togglePlayback() async {
    if (_audioPlayer.playing) {
      await pause();
    } else {
      await play();
    }
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    currentTrack.value = null;
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> skipToNext() async {
    await _audioPlayer.seekToNext();
  }

  Future<void> skipToPrevious() async {
    await _audioPlayer.seekToPrevious();
  }

  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  Stream<SequenceState?> get sequenceStateStream => _audioPlayer.sequenceStateStream;

  bool get playing => _audioPlayer.playing;
  Duration get position => _audioPlayer.position;
  Duration? get duration => _audioPlayer.duration;

  void dispose() {
    _audioPlayer.dispose();
  }
}