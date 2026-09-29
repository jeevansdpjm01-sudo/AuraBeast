import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'services/microsoft_auth_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  bool signup = false;
  bool loading = false;
  bool passwordVisible = false;
  String? message;
  bool messageIsError = true;

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void showMessage(String text, {bool isError = true}) {
    if (mounted) setState(() { message = text; messageIsError = isError; });
  }

  Future<void> emailAuth() async {
    final mail = email.text.trim();
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(mail)) return showMessage('Enter a valid email address.');
    if (password.text.length < 8) return showMessage('Use at least 8 characters for your password.');
    if (signup && username.text.trim().length < 3) return showMessage('Choose a display name with at least 3 characters.');
    setState(() { loading = true; message = null; });
    try {
      final credential = signup
          ? await AuthService.instance.signUpWithEmail(email: mail, password: password.text)
          : await AuthService.instance.signInWithEmail(email: mail, password: password.text);
      if (signup && credential.user != null) {
        final name = username.text.trim();
        await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({'username': name, 'email': mail, 'createdAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
        await credential.user!.updateDisplayName(name);
      }
    } on FirebaseAuthException catch (exception) { showMessage(authMessage(exception)); }
    finally { if (mounted) setState(() => loading = false); }
  }

  Future<void> resetPassword() async {
    final mail = email.text.trim();
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(mail)) return showMessage('Enter your email above first.');
    setState(() { loading = true; message = null; });
    try { await AuthService.instance.sendPasswordResetEmail(mail); showMessage('Reset link sent. Check your inbox.', isError: false); }
    on FirebaseAuthException catch (exception) { showMessage(authMessage(exception)); }
    finally { if (mounted) setState(() => loading = false); }
  }

  Future<void> social(String providerId) async {
    setState(() { loading = true; message = null; });
    try { await AuthService.instance.signInWithProvider(providerId); }
    on FirebaseAuthException catch (exception) { showMessage(authMessage(exception)); }
    finally { if (mounted) setState(() => loading = false); }
  }

  Future<void> microsoftSignIn() async {
    setState(() { loading = true; message = null; });
    try {
      await MicrosoftAuthService.instance.signIn();
      showMessage('Connected to your Microsoft account.', isError: false);
    } catch (error) {
      showMessage('Microsoft sign-in failed. Check the app registration settings and redirect URI.');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  String authMessage(FirebaseAuthException exception) => switch (exception.code) {
    'invalid-credential' || 'wrong-password' || 'user-not-found' => 'Email or password is incorrect.',
    'email-already-in-use' => 'That email is already registered.',
    'weak-password' => 'Choose a stronger password.',
    'popup-closed-by-user' => 'Sign-in was cancelled.',
    'too-many-requests' => 'Too many attempts. Try again in a moment.',
    'operation-not-allowed' => 'This sign-in method is disabled in Firebase Console.',
    'network-request-failed' => 'Network unavailable. Check your connection and try again.',
    'unauthorized-domain' => 'Add this web domain to Firebase Authentication authorized domains.',
    _ => 'We could not complete that request. Check your Firebase settings.',
  };

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xff090b0a),
    body: LayoutBuilder(builder: (context, constraints) {
      final wide = constraints.maxWidth >= 900;
      return Row(children: [
        if (wide) const Expanded(child: _BrandPanel()),
        Expanded(child: Center(child: SingleChildScrollView(padding: EdgeInsets.symmetric(horizontal: wide ? 72 : 28, vertical: 36), child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 410), child: _form()))),),
      ]);
    }),
  );

  Widget _form() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const _AuraMark(), const SizedBox(height: 30),
    Text(signup ? 'Make room for more music.' : 'Welcome back.', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
    const SizedBox(height: 8), Text(signup ? 'Create your account and tune into your next favorite.' : 'Your library is waiting for you.', style: TextStyle(color: Colors.white54, fontSize: 15)), const SizedBox(height: 30),
    if (signup) ...[_field(username, 'Display name', Icons.person_outline), const SizedBox(height: 14)],
    _field(email, 'Email address', Icons.mail_outline, type: TextInputType.emailAddress), const SizedBox(height: 14),
    _field(password, 'Password', Icons.lock_outline, obscure: !passwordVisible, suffix: IconButton(onPressed: () => setState(() => passwordVisible = !passwordVisible), icon: Icon(passwordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined))),
    if (!signup) Align(alignment: Alignment.centerRight, child: TextButton(onPressed: loading ? null : resetPassword, child: const Text('Forgot password?'))),
    if (message != null) ...[const SizedBox(height: 14), Container(width: double.infinity, padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: (messageIsError ? Colors.redAccent : const Color(0xff1ed760)).withValues(alpha: .12), borderRadius: BorderRadius.circular(8)), child: Text(message!, style: TextStyle(color: messageIsError ? Colors.redAccent.shade100 : const Color(0xff9ff2b8), fontSize: 13)))],
    const SizedBox(height: 18), SizedBox(width: double.infinity, height: 52, child: FilledButton(onPressed: loading ? null : emailAuth, child: loading ? const SizedBox(width: 21, height: 21, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black)) : Text(signup ? 'Create account' : 'Log in'))),
    const SizedBox(height: 26), Row(children: [Expanded(child: Divider(color: Colors.white24)), const Padding(padding: EdgeInsets.symmetric(horizontal: 14), child: Text('or continue with', style: TextStyle(color: Colors.white38, fontSize: 12))), Expanded(child: Divider(color: Colors.white24))]), const SizedBox(height: 18),
    Row(children: [Expanded(child: _social('G', 'Google', 'google.com')), const SizedBox(width: 10), Expanded(child: _social('f', 'Facebook', 'facebook.com'))]), const SizedBox(height: 10),
    SizedBox(width: double.infinity, height: 48, child: OutlinedButton.icon(onPressed: loading ? null : () => social('github.com'), icon: const Icon(Icons.code, size: 18), label: const Text('Continue with GitHub'))), const SizedBox(height: 10),
    SizedBox(width: double.infinity, height: 48, child: OutlinedButton.icon(onPressed: loading ? null : microsoftSignIn, icon: const Icon(Icons.account_circle_outlined, size: 18), label: const Text('Continue with Microsoft'))), const SizedBox(height: 16),
    Center(child: TextButton(onPressed: loading ? null : () => setState(() { signup = !signup; message = null; }), child: Text(signup ? 'Already have an account?  Log in' : 'New to AuraSound?  Create account'))), const SizedBox(height: 26),
    const Center(child: Text('By continuing, you agree to our Terms and Privacy Policy.', style: TextStyle(color: Colors.white30, fontSize: 11), textAlign: TextAlign.center)),
  ]);

  Widget _field(TextEditingController controller, String label, IconData icon, {TextInputType? type, bool obscure = false, Widget? suffix, String? hint}) => TextField(controller: controller, keyboardType: type, obscureText: obscure, style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: label, hintText: hint, prefixIcon: Icon(icon), suffixIcon: suffix));

  Widget _social(String mark, String label, String provider) => SizedBox(height: 48, child: OutlinedButton.icon(onPressed: loading ? null : () => social(provider), icon: Text(mark, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)), label: Text(label)));
}

class _AuraMark extends StatelessWidget {
  const _AuraMark();

  @override
  Widget build(BuildContext context) => Row(children: [Container(width: 32, height: 32, decoration: BoxDecoration(color: const Color(0xff1ed760), borderRadius: BorderRadius.circular(9)), child: const Icon(Icons.graphic_eq, color: Colors.black, size: 20)), const SizedBox(width: 10), const Text('AURASOUND', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 1.8))]);
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  @override
  Widget build(BuildContext context) => Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xff122c1b), Color(0xff0b1710), Color(0xff090b0a)])), padding: const EdgeInsets.all(72), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [const _AuraMark(), const SizedBox(height: 48), const Text('Find the sound\nthat feels like you.', style: TextStyle(fontSize: 47, height: 1.04, fontWeight: FontWeight.w800)), const SizedBox(height: 20), const Text('A calmer way to discover, collect, and play the music that moves with your mood.', style: TextStyle(color: Colors.white54, fontSize: 16, height: 1.5))]));
}