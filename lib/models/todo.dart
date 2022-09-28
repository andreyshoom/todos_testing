class Todo {
  String id;
  String title;
  bool tog;

  Todo({required this.id, required this.title, this.tog = false});

  void toggleBought() {
    tog = !tog;
  }

  factory Todo.fromJson(Map<String, Object?> json) => Todo(
        id: json['id'] as String,
        title: json['title'] as String,
        tog: json['tog'] as bool,
      );

  Map<String, Object?> toJson() => {
        'id': id,
        'title': title,
        'tog': tog,
      };
}
