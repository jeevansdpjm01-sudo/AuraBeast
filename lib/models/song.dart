import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  final String songId;
  final String ownerId;
  final String title;
  final String? artist;
  final String? album;
  final String? genre;
  final String? description;
  final String audioUrl;
  final String coverImageUrl;
  final String? lyrics;
  final Timestamp uploadedAt;
  final int playCount;
  final int likesCount;

  Song({
    required this.songId,
    required this.ownerId,
    required this.title,
    this.artist,
    this.album,
    this.genre,
    this.description,
    required this.audioUrl,
    required this.coverImageUrl,
    this.lyrics,
    required this.uploadedAt,
    this.playCount = 0,
    this.likesCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'songId': songId,
      'ownerId': ownerId,
      'title': title,
      'artist': artist,
      'album': album,
      'genre': genre,
      'description': description,
      'audioUrl': audioUrl,
      'coverImageUrl': coverImageUrl,
      'lyrics': lyrics,
      'uploadedAt': uploadedAt,
      'playCount': playCount,
      'likesCount': likesCount,
    };
  }

  factory Song.fromMap(Map<String, dynamic> m) {
    return Song(
      songId: m['songId'] as String? ?? (m['id'] as String? ?? ''),
      ownerId: m['ownerId'] as String? ?? '',
      title: m['title'] as String? ?? '',
      artist: m['artist'] as String?,
      album: m['album'] as String?,
      genre: m['genre'] as String?,
      description: m['description'] as String?,
      audioUrl: m['audioUrl'] as String? ?? '',
      coverImageUrl: m['coverImageUrl'] as String? ?? '',
      lyrics: m['lyrics'] as String?,
      uploadedAt: m['uploadedAt'] as Timestamp? ?? Timestamp.now(),
      playCount: (m['playCount'] as num?)?.toInt() ?? 0,
      likesCount: (m['likesCount'] as num?)?.toInt() ?? 0,
    );
  }
}
