import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/services/preferences_manager.dart';
import '../../models/task_model.dart';
import '../../core/components/task_list_widget.dart';

class HighPriorityScreen extends StatefulWidget {
  const HighPriorityScreen({super.key});

  @override
  State<HighPriorityScreen> createState() => _HighPriorityScreenState();
}

class _HighPriorityScreenState extends State<HighPriorityScreen> {
  void initState() {
    super.initState();

    _loadTask();
  }

  bool isCheck = false;
  List<TaskModel> highPriorityTasks = [];

  void _loadTask() async {
    final finalTask = PreferencesManager().getString("tasks");

    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;
      setState(() {
        highPriorityTasks = taskAfterDecode
            .map((element) => TaskModel.fromJson(element))
            .where(((element) => element.isHighPriority))
            .toList()
            .reversed
            .toList();
      });
    }
  }

  _deleteTask(int? id) async {
    List<TaskModel> tasks = [];
    if (id == null) return;

    final finalTask = PreferencesManager().getString("tasks");
    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;
      tasks = taskAfterDecode
          .map((element) => TaskModel.fromJson(element))
          .toList();
      tasks.removeWhere((e) => e.id == id);
    }
    setState(() {
      highPriorityTasks.removeWhere((task) => task.id == id);
    });

    final updatedTask = tasks
        .map((element) => element.toMap())
        .toList();
    await PreferencesManager().setString('tasks', jsonEncode(updatedTask));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("High Priority Tasks")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TaskListWidget(
          emptyMessage: "No Tasks Found",
          tasks: highPriorityTasks,
          onTap: (value, index) async {
            final tappedTask = highPriorityTasks[index!];
            setState(() {
              tappedTask.isDone = value ?? false;
              highPriorityTasks.removeAt(index);
            });

            final allData = PreferencesManager().getString("tasks");

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
          }, onEdit: (){
            _loadTask();
        },
        ),
      ),
    );
  }
}
