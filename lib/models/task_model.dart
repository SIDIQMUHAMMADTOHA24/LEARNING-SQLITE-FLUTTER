class TaskModel {
  final int status, id;
  final String content;

  TaskModel({required this.status, required this.id, required this.content});

  @override
  String toString() {
    return 'TaskModel{id: $id, content: $content, status: $status}';
  }
}
