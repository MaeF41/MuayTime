import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const fontFamily = 'SF Pro';


Future<void> loadFonts() async {
  final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized();
  binding.platformDispatcher.views.first.devicePixelRatio = 1.0;
  final fontManifest = await rootBundle.loadStructuredData<Iterable<dynamic>>(
    'FontManifest.json',
        (string) async => json.decode(string),
  );

  for (final Map<String, dynamic> font in fontManifest) {
    final fontLoader = FontLoader(font['family']);
    for (final Map<String, dynamic> fontType in font['fonts']) {
      fontLoader.addFont(rootBundle.load(fontType['asset']));
    }
    await fontLoader.load();
  }

  final fontLoader = FontLoader(fontFamily);

  final file = File('test/test_assets/SFMono.ttf');
  final fontBytes = file.readAsBytesSync();
  final byteData = ByteData.sublistView(fontBytes);
  fontLoader.addFont(Future.value(byteData));
  return fontLoader.load();
}