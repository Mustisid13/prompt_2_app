// ignore_for_file: public_member_api_docs, sort_constructors_first
class Task {
  String id;
  String title;
  String description;
  String priority; // 'high', 'medium', 'low'
  bool isCompleted;

  Task(
      {required this.id,
      required this.title,
      required this.description,
      required this.priority,
      this.isCompleted = false});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      priority: json['priority'],
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'isCompleted': isCompleted,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? priority,
    bool? isCompleted,
  }) {
    return Task(
      id:id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
