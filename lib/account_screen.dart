import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/auth_service.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});
  @override State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final name = TextEditingController();
  String? message;

  @override
  void initState() {
    super.initState();
    name.text = AuthService.instance.currentUser?.displayName ?? '';
  }

  @override
  void dispose() { name.dispose(); super.dispose(); }

  Future<void> save() async {
    final value = name.text.trim();
    if (value.isEmpty) { setState(() => message = 'Enter a display name.'); return; }
    await AuthService.instance.currentUser?.updateDisplayName(value);
    if (mounted) setState(() => message = 'Profile updated.');
  }

  Future<void> resetPassword() async {
    final email = AuthService.instance.currentUser?.email;
    try {
      if (email != null) await AuthService.instance.sendPasswordResetEmail(email);
      if (mounted) setState(() => message = 'Password reset email sent.');
    } on FirebaseAuthException catch (exception) {
      if (mounted) setState(() => message = exception.code == 'unknown' ? 'Password reset is not enabled in Firebase yet.' : 'Could not send the reset email.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    return ListView(padding: const EdgeInsets.fromLTRB(24, 26, 24, 110), children: [
      const Text('Account', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
      const SizedBox(height: 8),
      const Text('Manage your AuraSound identity and security.', style: TextStyle(color: Colors.white54)),
      const SizedBox(height: 26),
      ListTile(contentPadding: EdgeInsets.zero, leading: const CircleAvatar(backgroundColor: Color(0xff6e3ba4), child: Icon(Icons.person)), title: Text(user?.email ?? 'Signed in'), subtitle: const Text('Authenticated account', style: TextStyle(color: Colors.white54))),
      const SizedBox(height: 18),
      TextField(controller: name, decoration: const InputDecoration(labelText: 'Display name', prefixIcon: Icon(Icons.badge_outlined))),
      const SizedBox(height: 14),
      FilledButton.icon(onPressed: save, icon: const Icon(Icons.save_outlined), label: const Text('Save profile')),
      ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.lock_reset, color: Color(0xffb784ff)), title: const Text('Reset password'), onTap: resetPassword),
      ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.logout, color: Color(0xffb784ff)), title: const Text('Log out'), onTap: AuthService.instance.signOut),
      ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.delete_outline, color: Colors.redAccent), title: const Text('Delete account', style: TextStyle(color: Colors.redAccent)), onTap: () => AuthService.instance.currentUser?.delete()),
      if (message != null) Padding(padding: const EdgeInsets.only(top: 14), child: Text(message!, style: const TextStyle(color: Color(0xffc69dff)))),
    ]);
  }
}
