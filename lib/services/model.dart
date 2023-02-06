class Todo {
  final String title;
  final String date;
  final String description;
  final bool isDone;

  Todo(
      {required this.title,
      required this.date,
      required this.description,
      required this.isDone});

  factory Todo.fromJson(Map<String, dynamic> data) {
    return Todo(
        date: data['due_date'],
        title: data['title'],
        description: data['description'],
        isDone: data['isDone']);
  }
}
