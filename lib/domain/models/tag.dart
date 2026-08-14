final class TaskTag {
  TaskTag({
    required String id,
    required String name,
    this.colorValue = 0xFF6A7A90,
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
}
