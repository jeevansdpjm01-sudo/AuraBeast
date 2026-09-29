import 'package:flutter/material.dart';
import 'package:aurabeast/services/auth_service.dart';
import 'package:aurabeast/widgets/app_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _autoPlayNext = true;
  int _cacheLimit = 500; // MB

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Settings'),
      body: ListView(
        children: [
          // Account section
          ListTile(
            leading: const Icon(Icons.account_circle, color: Colors.deepPurple),
            title: Text(user?.displayName ?? 'Microsoft Account'),
            subtitle: Text(user?.email ?? 'Not signed in'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to account screen if needed
            },
          ),
          const Divider(height: 1),
          // Preferences
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.deepPurple),
            title: const Text('Notifications'),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() => _notificationsEnabled = value);
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.autorenew, color: Colors.deepPurple),
            title: const Text('Auto-play next'),
            trailing: Switch(
              value: _autoPlayNext,
              onChanged: (value) {
                setState(() => _autoPlayNext = value);
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.storage, color: Colors.deepPurple),
            title: const Text('Cache limit'),
            subtitle: Text('$_cacheLimit MB'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Show dialog to change cache limit
            },
          ),
          const Divider(height: 1),
          // About
          ListTile(
            leading: const Icon(Icons.info, color: Colors.deepPurple),
            title: const Text('About AuraBeast'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Show about dialog
            },
          ),
          const Divider(height: 1),
          // Sign out
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Sign out',
                style: TextStyle(color: Colors.red)),
            onTap: () async {
              await AuthService.instance.signOut();
              if (!mounted) return;
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}