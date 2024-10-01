import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task_model.dart';

class TaskRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Task>> getTasks() async {
    final tasksSnapshot = await firestore.collection('tasks').get();
    return tasksSnapshot.docs.map((doc) {
      Task tsk = Task.fromJson(doc.data());

      return tsk.copyWith(id: doc.id);
    }).toList();
  }

  Future<void> addTask(Task task) async {
    await firestore.collection('tasks').add(task.toJson());
  }

  Future<void> updateTask(Task task) async {
    await firestore.collection('tasks').doc(task.id).update(task.toJson());
  }

  Future<void> deleteTask(String taskId) async {
    await firestore.collection('tasks').doc(taskId).delete();
  }
}
