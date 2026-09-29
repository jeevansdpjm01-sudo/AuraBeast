import 'package:just_audio/just_audio.dart';

import 'microsoft_auth_service.dart';

class AuraMusicPlayerService {
  AuraMusicPlayerService._();

  static final AuraMusicPlayerService instance = AuraMusicPlayerService._();

  final AudioPlayer _player = AudioPlayer();

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<bool> get playingStream => _player.playingStream;

  Future<void> playFromOneDriveUrl({
    required String fileUrl,
    required String title,
    required String artist,
  }) async {
    final token = await MicrosoftAuthService.instance.ensureAccessToken();
    await _player.setUrl(
      fileUrl,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
      preload: true,
    );
    await _player.play();
  }

  Future<void> playPause() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> seek(Duration duration) async => _player.seek(duration);

  Future<void> setLoopMode(bool enabled) async {
    await _player.setLoopMode(enabled ? LoopMode.one : LoopMode.off);
  }

  Future<void> setShuffle(bool enabled) async {
    await _player.setShuffleModeEnabled(enabled);
  }

  Future<void> next() async {
    final position = _player.position;
    if (position > const Duration(seconds: 3)) {
      await _player.seek(Duration.zero);
      return;
    }
    await _player.seekToNext();
  }

  Future<void> previous() async {
    final position = _player.position;
    if (position > const Duration(seconds: 3)) {
      await _player.seek(Duration.zero);
      return;
    }
    await _player.seekToPrevious();
  }

  Future<void> stop() async => _player.stop();

  Future<void> dispose() async => _player.dispose();
}
