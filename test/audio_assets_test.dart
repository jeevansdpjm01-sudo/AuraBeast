import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('sample songs are available as Flutter assets', (tester) async {
    final assets = [
      'assets/songs/makeit.wav',
      'assets/songs/song2.wav',
      'assets/songs/song3.wav',
    ];

    for (final asset in assets) {
      expect(() async => rootBundle.load(asset), returnsNormally);
    }
  });
}
