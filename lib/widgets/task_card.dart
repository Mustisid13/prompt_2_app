import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/task_bloc.dart';
import '../blocs/task_event.dart';
import '../models/task_model.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/taskDetail', arguments: task),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      task.priority,
                      style: TextStyle(
                        fontSize: 14,
                        color: task.priority == 'high'
                            ? Colors.red
                            : task.priority == 'medium'
                                ? Colors.orange
                                : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              Checkbox(
                value: task.isCompleted,
                onChanged: (bool? value) {
                  // Handle task completion toggle here.
                  // Update the task completion status
                  final updatedTask = task.copyWith(isCompleted: value!);
                  BlocProvider.of<TaskBloc>(context)
                      .add(UpdateTask(updatedTask));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
