import 'package:flutter/material.dart';
import 'package:aurabeast/screens/home_screen.dart';
import 'package:aurabeast/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.instance.init();
  runApp(const AuraBeastApp());
}

class AuraBeastApp extends StatelessWidget {
  const AuraBeastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AuraBeast',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomeScreen(),
      routes: {
        '/my-music': (context) => const MyMusicScreen(),
        '/upload': (context) => const UploadScreen(),
        '/search': (context) => const SearchScreen(),
        '/player': (context) => const MusicPlayerScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}