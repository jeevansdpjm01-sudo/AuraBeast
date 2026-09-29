import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'audio_service.dart';
import 'account_screen.dart';
import 'upload_portal.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});
  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  bool downloadsOnly = false;
  bool notifications = true;
  bool privateProfile = false;
  double volume = .8;
  List<String> downloadedSongs = [];
  SharedPreferences? prefs;

  @override
  void initState() { super.initState(); load(); }
  Future<void> load() async {
    prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      downloadsOnly = prefs?.getBool('downloadsOnly') ?? false;
      notifications = prefs?.getBool('notifications') ?? true;
      privateProfile = prefs?.getBool('privateProfile') ?? false;
      volume = prefs?.getDouble('volume') ?? .8;
      downloadedSongs = prefs?.getStringList('downloadedSongs') ?? [];
    });
    await audioService.setVolume(volume);
  }
  Future<void> save(String key, bool value) async => prefs?.setBool(key, value);
  Future<void> downloadDemoSongs() async {
    downloadedSongs = ['neon', 'velvet', 'signals', 'soft', 'city', 'higher'];
    await prefs?.setStringList('downloadedSongs', downloadedSongs);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.fromLTRB(24, 26, 24, 110), children: [
        const Text('Settings', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        const Text('Make AuraSound work your way.', style: TextStyle(color: Colors.white54)),
        const SizedBox(height: 25),
        const Text('Playback', style: TextStyle(color: Color(0xffb784ff), fontWeight: FontWeight.w700)),
        ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.person_outline, color: Color(0xffb784ff)), title: const Text('Account management'), subtitle: const Text('Profile, password, logout, and account deletion', style: TextStyle(color: Colors.white54)), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountScreen()))),
        ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.cloud_upload_outlined, color: Color(0xffb784ff)), title: const Text('Upload a song'), subtitle: const Text('Publish original or royalty-free audio', style: TextStyle(color: Colors.white54)), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UploadPortal()))),
        ListTile(contentPadding: EdgeInsets.zero, title: const Text('Volume'), subtitle: Slider(value: volume, onChanged: (value) { setState(() => volume = value); audioService.setVolume(value); prefs?.setDouble('volume', value); }, activeColor: const Color(0xffb784ff)), trailing: Text('${(volume * 100).round()}%')),
        ValueListenableBuilder<bool>(valueListenable: audioService.shuffleEnabled, builder: (_, enabled, __) => SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('Shuffle by default'), value: enabled, onChanged: audioService.setShuffle)),
        ListTile(contentPadding: EdgeInsets.zero, title: const Text('Repeat mode'), trailing: ValueListenableBuilder(valueListenable: audioService.repeatMode, builder: (_, mode, __) => DropdownButton<LoopMode>(value: mode, items: const [DropdownMenuItem(value: LoopMode.off, child: Text('Off')), DropdownMenuItem(value: LoopMode.all, child: Text('All')), DropdownMenuItem(value: LoopMode.one, child: Text('One'))], onChanged: (value) { if (value != null) audioService.setRepeat(value); }))),
        const SizedBox(height: 14),
        const Text('Privacy and notifications', style: TextStyle(color: Color(0xffb784ff), fontWeight: FontWeight.w700)),
        SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('Private profile'), value: privateProfile, onChanged: (value) { setState(() => privateProfile = value); save('privateProfile', value); }),
        SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('New release notifications'), value: notifications, onChanged: (value) { setState(() => notifications = value); save('notifications', value); }),
        SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('Download over Wi-Fi only'), value: downloadsOnly, onChanged: (value) { setState(() => downloadsOnly = value); save('downloadsOnly', value); }),
        const SizedBox(height: 14),
        const Text('Storage', style: TextStyle(color: Color(0xffb784ff), fontWeight: FontWeight.w700)),
        ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.download_done, color: Color(0xffb784ff)), title: Text('Offline songs (${downloadedSongs.length})'), subtitle: const Text('Save demo songs for offline-ready playback.', style: TextStyle(color: Colors.white54)), trailing: TextButton(onPressed: downloadDemoSongs, child: const Text('Download all'))),
        ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.delete_sweep_outlined, color: Colors.white54), title: const Text('Clear downloaded cache'), onTap: () async { final store = await SharedPreferences.getInstance(); await store.remove('downloadedSongs'); if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Downloaded cache cleared.'))); }),
      ]);
}
