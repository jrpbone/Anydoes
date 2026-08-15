import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

void main() {
  (int, int) pngDimensions(File file) {
    final bytes = file.readAsBytesSync();
    expect(bytes.length, greaterThanOrEqualTo(24), reason: file.path);
    final data = ByteData.sublistView(Uint8List.fromList(bytes));
    expect(data.getUint32(0), 0x89504E47, reason: file.path);
    return (data.getUint32(16), data.getUint32(20));
  }

  test('launcher PNG assets have their required platform dimensions', () {
    const expected = <String, int>{
      'assets/branding/anydoes_app_icon.png': 1024,
      'android/app/src/main/res/mipmap-mdpi/ic_launcher.png': 48,
      'android/app/src/main/res/mipmap-hdpi/ic_launcher.png': 72,
      'android/app/src/main/res/mipmap-xhdpi/ic_launcher.png': 96,
      'android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png': 144,
      'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png': 192,
      'android/app/src/main/res/mipmap-mdpi/ic_launcher_foreground.png': 108,
      'android/app/src/main/res/mipmap-hdpi/ic_launcher_foreground.png': 162,
      'android/app/src/main/res/mipmap-xhdpi/ic_launcher_foreground.png': 216,
      'android/app/src/main/res/mipmap-xxhdpi/ic_launcher_foreground.png': 324,
      'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher_foreground.png': 432,
      'web/favicon.png': 32,
      'web/icons/Icon-192.png': 192,
      'web/icons/Icon-512.png': 512,
      'web/icons/Icon-maskable-192.png': 192,
      'web/icons/Icon-maskable-512.png': 512,
      'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_16.png': 16,
      'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_32.png': 32,
      'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_64.png': 64,
      'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_128.png': 128,
      'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_256.png': 256,
      'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_512.png': 512,
      'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_1024.png': 1024,
    };

    for (final entry in expected.entries) {
      final file = File(entry.key);
      expect(file.existsSync(), isTrue, reason: entry.key);
      expect(pngDimensions(file), (
        entry.value,
        entry.value,
      ), reason: entry.key);
    }
  });

  test('Windows launcher icon contains multiple resolutions', () {
    final file = File('windows/runner/resources/app_icon.ico');
    final bytes = file.readAsBytesSync();
    final data = ByteData.sublistView(Uint8List.fromList(bytes));

    expect(data.getUint16(0, Endian.little), 0);
    expect(data.getUint16(2, Endian.little), 1);
    expect(data.getUint16(4, Endian.little), greaterThanOrEqualTo(7));
  });
}
