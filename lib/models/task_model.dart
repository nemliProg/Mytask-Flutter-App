class Task {
  String id;
  String task;
  String important;
  bool done;

  Task({this.id = '',
      required this.task,
      required this.important,
      this.done = false});

  Map<String, dynamic> toJson() =>
      {'id': id, 'task': task, 'important': important, 'done': done};

  static Task fromJson(Map<String, dynamic> json) => Task(id: json['id'], task: json['task'], important: json['important'],done: json['done']);

}
