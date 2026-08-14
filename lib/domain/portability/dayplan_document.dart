import 'dart:convert';

import 'package:anydoes/domain/portability/canonical_json.dart';
import 'package:crypto/crypto.dart';

enum DayplanKind {
  fullBackup('full_backup'),
  sharedList('shared_list');

  const DayplanKind(this.wireName);
  final String wireName;
}

final class DayplanMetadata {
  DayplanMetadata({
    required DateTime exportedAt,
    required this.sourceTimeZone,
    required this.appVersion,
    required this.platform,
    this.sharedListId,
  }) : exportedAt = exportedAt.toUtc();

  final DateTime exportedAt;
  final String sourceTimeZone;
  final String appVersion;
  final String platform;
  final String? sharedListId;
}

final class DayplanDocument {
  DayplanDocument({
    required this.schemaVersion,
    required this.kind,
    required this.exportedAt,
    required this.sourceTimeZone,
    required Map<String, Object?> app,
    required Map<String, Object?> payload,
    required this.checksum,
  }) : app = Map.unmodifiable(app),
       payload = Map.unmodifiable(payload);

  final int schemaVersion;
  final DayplanKind kind;
  final String exportedAt;
  final String sourceTimeZone;
  final Map<String, Object?> app;
  final Map<String, Object?> payload;
  final String checksum;

  bool get hasValidChecksum =>
      checksum ==
      sha256
          .convert(utf8.encode(CanonicalJson.encode(payload)))
          .toString()
          .toLowerCase();
}
