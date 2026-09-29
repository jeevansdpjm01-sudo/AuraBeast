import 'package:flutter/material.dart';

import '../services/microsoft_auth_service.dart';
import '../services/microsoft_graph_service.dart';

class MicrosoftConnectScreen extends StatefulWidget {
  const MicrosoftConnectScreen({super.key});

  @override
  State<MicrosoftConnectScreen> createState() => _MicrosoftConnectScreenState();
}

class _MicrosoftConnectScreenState extends State<MicrosoftConnectScreen> {
  bool _loading = false;
  String? _status;
  String? _accountName;

  Future<void> _connect() async {
    setState(() {
      _loading = true;
      _status = null;
    });

    try {
      await MicrosoftAuthService.instance.signIn();
      final profile = await MicrosoftGraphService.instance.getProfile();
      if (!mounted) return;
      setState(() {
        _accountName = profile.displayName;
        _status = 'Connected to ${profile.displayName}';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _status = 'Microsoft sign-in failed: $error';
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _signOut() async {
    await MicrosoftAuthService.instance.signOut();
    if (!mounted) return;
    setState(() {
      _status = 'Signed out of Microsoft';
      _accountName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Microsoft account')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AuraBeast uses your own Microsoft OneDrive',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Every upload and download stays inside the signed-in user\'s OneDrive account. No shared account is used.',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 20),
                    if (_accountName != null)
                      Text(
                        'Signed in as: $_accountName',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    if (_status != null) ...[
                      const SizedBox(height: 12),
                      Text(_status!),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _loading ? null : _connect,
                        icon: const Icon(Icons.account_circle_outlined),
                        label: Text(_loading ? 'Connecting…' : 'Connect Microsoft Account'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _signOut,
                        icon: const Icon(Icons.logout),
                        label: const Text('Sign out'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
