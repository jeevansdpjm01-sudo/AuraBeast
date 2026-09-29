import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/song.dart';

class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUserIfNotExists(Map<String, dynamic> userData, String uid) async {
    final ref = _db.collection('users').doc(uid);
    final snapshot = await ref.get();
    if (!snapshot.exists) {
      await ref.set(userData);
    }
  }

  Future<DocumentReference> createSong(Song song) async {
    final ref = _db.collection('songs').doc(song.songId);
    await ref.set(song.toMap());
    return ref;
  }

  Future<void> updateSong(String songId, Map<String, dynamic> updates) async {
    await _db.collection('songs').doc(songId).update(updates);
  }

  Future<void> deleteSong(String songId) async {
    await _db.collection('songs').doc(songId).delete();
  }

  Stream<List<Song>> getSongsByOwner(String ownerId) {
    return _db.collection('songs').where('ownerId', isEqualTo: ownerId).orderBy('uploadedAt', descending: true).snapshots().map((snap) {
      return snap.docs.map((d) => Song.fromMap(d.data() as Map<String, dynamic>)).toList();
    });
  }
}
