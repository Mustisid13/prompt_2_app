import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/task_bloc.dart';
import '../blocs/task_event.dart';
import '../models/task_model.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              BlocProvider.of<TaskBloc>(context).add(DeleteTask(task.id));
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Priority: ${task.priority}',
              style: TextStyle(
                fontSize: 18,
                color: task.priority == 'high'
                    ? Colors.red
                    : task.priority == 'medium'
                        ? Colors.orange
                        : Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              task.description,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
