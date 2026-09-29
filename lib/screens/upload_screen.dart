Future<void> _upload() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  if (_audioFile == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select an audio file'),
      ),
    );
    return;
  }

  if (_coverFile == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select a cover image'),
      ),
    );
    return;
  }

  final user = AuthService.instance.currentUser;

  if (user == null) {
    Navigator.of(context).pushReplacementNamed('/login');
    return;
  }

  setState(() {
    _isUploading = true;
    _progress = 0.0;
  });

  final id = const Uuid().v4();

  final audioExt =
      _audioFile!.path.split('.').last.toLowerCase();

  final coverExt =
      _coverFile!.path.split('.').last.toLowerCase();

  final audioPath =
      'songs/${user.uid}/$id.$audioExt';

  final coverPath =
      'covers/${user.uid}/$id.$coverExt';

  try {
    // ==============================
    // AUDIO UPLOAD
    // ==============================

    debugPrint('Starting audio upload...');
    debugPrint('Audio path: $audioPath');

    final audioBytes = await _audioFile!.readAsBytes();

    await _supabase.storage
        .from('songs')
        .uploadBinary(
          audioPath,
          audioBytes,
          fileOptions: const FileOptions(
            upsert: false,
          ),
        );

    debugPrint('Audio upload successful');

    setState(() {
      _progress = 0.5;
    });

    // ==============================
    // COVER UPLOAD
    // ==============================

    debugPrint('Starting cover upload...');
    debugPrint('Cover path: $coverPath');

    final coverBytes = await _coverFile!.readAsBytes();

    await _supabase.storage
        .from('songs')
        .uploadBinary(
          coverPath,
          coverBytes,
          fileOptions: const FileOptions(
            upsert: false,
          ),
        );

    debugPrint('Cover upload successful');

    setState(() {
      _progress = 0.8;
    });

    // ==============================
    // PUBLIC URLS
    // ==============================

    final audioUrl = _supabase.storage
        .from('songs')
        .getPublicUrl(audioPath);

    final coverUrl = _supabase.storage
        .from('songs')
        .getPublicUrl(coverPath);

    debugPrint('Audio URL: $audioUrl');
    debugPrint('Cover URL: $coverUrl');

    // ==============================
    // FIRESTORE
    // ==============================

    final song = Song(
      songId: id,
      ownerId: user.uid,
      title: _titleCtrl.text.trim(),
      artist: _artistCtrl.text.trim(),
      album: _albumCtrl.text.trim(),
      genre: _genreCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      audioUrl: audioUrl,
      coverImageUrl: coverUrl,
      lyrics: _lyricsCtrl.text.trim().isEmpty
          ? null
          : _lyricsCtrl.text.trim(),
      uploadedAt: Timestamp.now(),
    );

    await FirestoreService.instance.createSong(song);

    debugPrint('Firestore save successful');

    setState(() {
      _progress = 1.0;
      _isUploading = false;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Upload successful'),
      ),
    );

    Navigator.of(context).pop();
  } catch (e, stackTrace) {
    debugPrint('================================');
    debugPrint('UPLOAD ERROR');
    debugPrint('$e');
    debugPrint('$stackTrace');
    debugPrint('================================');

    setState(() {
      _isUploading = false;
      _progress = 0.0;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Upload failed:\n$e',
        ),
        duration: const Duration(seconds: 8),
      ),
    );
  }
}
