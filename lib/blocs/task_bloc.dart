import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/task_model.dart';
import '../repositories/task_repositories.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;
  TaskBloc({required this.taskRepository}) : super(TaskLoading()) {
    on<LoadTasks>((event, emit) async {
      emit(TaskLoading());
      try {
        final tasks = await taskRepository.getTasks();
        emit(TaskLoaded(tasks));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });

    on<DeleteTask>(
      (event, emit) async{
        await _deleteTask(event.taskId, emit);
      },
    );
    on<UpdateTask>(
      (event, emit) async{
        await _updateTask(event.task, emit);
      },
    );
    on<AddTask>(
      (event, emit) async{
        await _addTask(event.task, emit);
      },
    );
  }

  Future<void> _addTask(Task task, Emitter<TaskState> emit) async {
    try {
      await taskRepository.addTask(task);
      final tasks = await taskRepository.getTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _updateTask(Task task, Emitter<TaskState> emit) async {
    try {
      await taskRepository.updateTask(task);
      final tasks = await taskRepository.getTasks(); // Refresh tasks
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _deleteTask(String taskId, Emitter<TaskState> emit) async {
    try {
      await taskRepository.deleteTask(taskId);
      final tasks = await taskRepository.getTasks(); // Refresh tasks
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
