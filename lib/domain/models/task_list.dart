final class TaskList {
  TaskList({
    required String id,
    required String name,
    required this.createdAt,
    this.colorValue = 0xFF2878E3,
    this.iconCodePoint = 0xe156,
    this.isInbox = false,
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
  final int iconCodePoint;
  final bool isInbox;
  final DateTime createdAt;
}
