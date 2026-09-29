import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads a file to [path] (e.g. 'songs/{userId}/{filename}') and returns the download URL.
  Future<String> uploadFile({
    required File file,
    required String path,
    required void Function(double progress)? onProgress,
  }) async {
    final ref = _storage.ref().child(path);
    final uploadTask = ref.putFile(file);

    uploadTask.snapshotEvents.listen((snapshot) {
      final progress = snapshot.bytesTransferred / (snapshot.totalBytes == 0 ? 1 : snapshot.totalBytes);
      if (onProgress != null) onProgress(progress);
    });

    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }
}
