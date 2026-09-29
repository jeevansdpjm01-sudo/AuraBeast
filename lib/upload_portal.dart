import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class UploadPortal extends StatefulWidget {
  const UploadPortal({super.key});
  @override
  State<UploadPortal> createState() => _UploadPortalState();
}

class _UploadPortalState extends State<UploadPortal> {
  final title = TextEditingController();
  final artist = TextEditingController();
  final genre = TextEditingController();
  PlatformFile? audio;
  PlatformFile? cover;
  bool uploading = false;
  String? error;

  @override
  void dispose() { title.dispose(); artist.dispose(); genre.dispose(); super.dispose(); }

  Future<void> pickAudio() async {
    final result = await FilePicker.pickFiles(type: FileType.audio);
    if (result.isNotEmpty) setState(() => audio = result.single);
  }

  Future<void> pickCover() async {
    final result = await FilePicker.pickFiles(type: FileType.image);
    if (result.isNotEmpty) setState(() => cover = result.single);
  }

  Future<void> upload() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    if (title.text.trim().isEmpty || artist.text.trim().isEmpty || audio == null) {
      setState(() => error = 'Add a title, artist, and audio file.');
      return;
    }
    setState(() { uploading = true; error = null; });
    try {
      final id = const Uuid().v4();
      final audioRef = FirebaseStorage.instance.ref('songs/${user.uid}/$id-${audio!.name}');
      final audioSnap = await audioRef.putData(await audio!.readAsBytes());
      String? coverUrl;
      if (cover != null) {
        final coverRef = FirebaseStorage.instance.ref('covers/${user.uid}/$id-${cover!.name}');
        final coverSnap = await coverRef.putData(await cover!.readAsBytes());
        coverUrl = await coverSnap.ref.getDownloadURL();
      }
      await FirebaseFirestore.instance.collection('songs').doc(id).set({
        'ownerId': user.uid, 'title': title.text.trim(), 'artist': artist.text.trim(),
        'genre': genre.text.trim(), 'audioUrl': await audioSnap.ref.getDownloadURL(),
        'coverImageUrl': coverUrl, 'createdAt': FieldValue.serverTimestamp(),
      });
      if (mounted) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Song uploaded successfully.'))); Navigator.pop(context); }
    } catch (_) {
      if (mounted) setState(() => error = 'Upload failed. Check your connection and retry.');
    } finally { if (mounted) setState(() => uploading = false); }
  }

  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Upload song')), body: ListView(padding: const EdgeInsets.all(24), children: [
    const Text('Share your sound', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
    const SizedBox(height: 8), const Text('Upload original or royalty-free audio only.', style: TextStyle(color: Colors.white54)),
    const SizedBox(height: 24),
    TextField(controller: title, decoration: const InputDecoration(labelText: 'Song title', prefixIcon: Icon(Icons.music_note))),
    const SizedBox(height: 12), TextField(controller: artist, decoration: const InputDecoration(labelText: 'Artist name', prefixIcon: Icon(Icons.person_outline))),
    const SizedBox(height: 12), TextField(controller: genre, decoration: const InputDecoration(labelText: 'Genre or mood', prefixIcon: Icon(Icons.category_outlined))),
    const SizedBox(height: 22), OutlinedButton.icon(onPressed: uploading ? null : pickAudio, icon: const Icon(Icons.audio_file), label: Text(audio == null ? 'Choose audio' : audio!.name)),
    const SizedBox(height: 10), OutlinedButton.icon(onPressed: uploading ? null : pickCover, icon: const Icon(Icons.image_outlined), label: Text(cover == null ? 'Choose cover (optional)' : cover!.name)),
    if (error != null) Padding(padding: const EdgeInsets.only(top: 14), child: Text(error!, style: const TextStyle(color: Colors.redAccent))),
    const SizedBox(height: 24), FilledButton.icon(onPressed: uploading ? null : upload, icon: const Icon(Icons.cloud_upload_outlined), label: Text(uploading ? 'Uploading...' : 'Upload song')),
  ]));
}
