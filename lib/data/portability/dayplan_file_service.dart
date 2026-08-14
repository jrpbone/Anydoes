import 'dart:convert';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

abstract interface class DayplanFileGateway {
  Future<String?> read();
  Future<bool> saveFullBackup(String source, {required String suggestedName});
  Future<bool> saveSharedList(String source, {required String suggestedName});
  Future<String> localTimeZone();
}

final class DayplanFileService implements DayplanFileGateway {
  static const _types = [
    XTypeGroup(
      label: 'Anydoes dayplan',
      extensions: ['dayplan'],
      mimeTypes: ['application/json'],
      uniformTypeIdentifiers: ['public.json'],
    ),
  ];

  @override
  Future<String?> read() async {
    final file = await openFile(acceptedTypeGroups: _types);
    return file?.readAsString();
  }

  @override
  Future<bool> saveFullBackup(String source, {required String suggestedName}) =>
      _save(source, suggestedName);

  @override
  Future<bool> saveSharedList(String source, {required String suggestedName}) =>
      _save(source, suggestedName);

  Future<bool> _save(String source, String suggestedName) async {
    final normalized = suggestedName.toLowerCase().endsWith('.dayplan')
        ? suggestedName
        : '$suggestedName.dayplan';
    final location = await getSaveLocation(
      acceptedTypeGroups: _types,
      suggestedName: normalized,
    );
    if (location == null) return false;
    final path = location.path.toLowerCase().endsWith('.dayplan')
        ? location.path
        : '${location.path}.dayplan';
    final file = XFile.fromData(
      Uint8List.fromList(utf8.encode(source)),
      mimeType: 'application/json',
      name: normalized,
    );
    await file.saveTo(path);
    return true;
  }

  @override
  Future<String> localTimeZone() async {
    try {
      return (await FlutterTimezone.getLocalTimezone()).identifier;
    } catch (_) {
      return DateTime.now().timeZoneName;
    }
  }
}
