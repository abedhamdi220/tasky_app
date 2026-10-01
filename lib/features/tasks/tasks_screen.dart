import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tasky/core/components/task_list_widget.dart';
import '../../core/constants/storage_key.dart';
import '../../core/services/preferences_manager.dart';
import '../../models/task_model.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  void initState() {
    super.initState();

    _loadTask();
  }

  bool isCheck = false;
  List<TaskModel> todoTasks = [];

  void _loadTask() async {
    final finalTask = PreferencesManager().getString(StorageKey.tasks);

    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;
      setState(() {
        todoTasks = taskAfterDecode
            .map((element) => TaskModel.fromJson(element))
            .where(((element) => element.isDone == false))
            .toList();
      });
    }
  }

  _deleteTask(int? id) async {
    List<TaskModel> tasks = [];
    if (id == null) return;

    final finalTask = PreferencesManager().getString(StorageKey.tasks);
    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;
      tasks = taskAfterDecode
          .map((element) => TaskModel.fromJson(element))
          .toList();
      tasks.removeWhere((e) => e.id == id);
    }
    setState(() {
      todoTasks.removeWhere((task) => task.id == id);
    });

    final updatedTask = tasks.map((element) => element.toMap()).toList();
    await PreferencesManager().setString('tasks', jsonEncode(updatedTask));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(18),
          child: Text(
            'To Do Tasks',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TaskListWidget(
              emptyMessage: "No Tasks Found",
              tasks: todoTasks,
              onTap: (value, index) async {
                final tappedTask = todoTasks[index!];
                setState(() {
                  tappedTask.isDone = value ?? false;
                  todoTasks.removeAt(index);
                });

                final allData = PreferencesManager().getString('tasks');

                if (allData != null) {
                  List<TaskModel> allDataList = (jsonDecode(allData) as List)
                      .map((element) => TaskModel.fromJson(element))
                      .toList();

                  final newIndex = allDataList.indexWhere(
                    (e) => e.id == tappedTask.id,
                  );

                  if (newIndex != -1) {
                    allDataList[newIndex] = tappedTask;
                    await PreferencesManager().setString(
                      'tasks',
                      jsonEncode(allDataList),
                    );
                  }
                }
              },
              onDelete: (int? id) {
                _deleteTask(id);
              },
              onEdit: () {
                _loadTask();
              },
            ),
          ),
        ),
      ],
    );
  }
}
