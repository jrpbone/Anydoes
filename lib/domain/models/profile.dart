final class LocalProfile {
  LocalProfile({
    required String id,
    required String name,
    this.colorValue = 0xFF2878E3,
    this.isMe = false,
  }) : id = id.trim(),
       name = name.trim() {
    if (this.id.isEmpty) {
      throw ArgumentError.value(id, 'id', 'Required');
    }
    if (this.name.isEmpty) {
      throw ArgumentError.value(name, 'name', 'Cannot be blank');
    }
  }

  final String id;
  final String name;
  final int colorValue;
  final bool isMe;

  String get initials {
    final words = name
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    return words.take(2).map((word) => word[0].toUpperCase()).join();
  }
}
