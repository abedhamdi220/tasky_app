import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tasky/models/task_model.dart';
import '../../../core/constants/storage_key.dart';
import '../../../core/services/preferences_manager.dart';

class TasksController with ChangeNotifier {
  bool isLoading = false;
  List<TaskModel> tasks = [];
  List<TaskModel> completedTasks = [];
  List<TaskModel> todoTasks = [];
  List<TaskModel> highPriorityTasks = [];
  int totalTasks = 0;
  int totalDoneTasks = 0;
  double precent = 0;

  void init() {
    _loadTasks();
  }

  void _loadTasks() async {
    isLoading = true;
    final finalTask = PreferencesManager().getString(StorageKey.tasks);

    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;

      tasks = taskAfterDecode
          .map((element) => TaskModel.fromJson(element))
          .toList();
      calculatePercent();
      todoTasks = tasks.where((element) => !element.isDone).toList();
      completedTasks = tasks.where((element) => element.isDone).toList();
      highPriorityTasks = tasks
          .where(((element) => element.isHighPriority))
          .toList()
          .reversed
          .toList();
    }
    isLoading = false;
    notifyListeners();
  }

  void doneTask(bool? value, int? index) async {
    if (index == null) return;
    tasks[index].isDone = value ?? false;
    calculatePercent();
    final  updatedTask = tasks.map((e)=>e.toJson()).toList();


    await PreferencesManager().setString(StorageKey.tasks, jsonEncode(updatedTask));
    _loadTasks();
  }
  void doneTodoTask(bool? value, int? index) async {
    if (index == null) return;
    todoTasks[index].isDone = value ?? false;
    calculatePercent();
    final int newIndex = tasks.indexWhere((e) => e.id == todoTasks[index].id);
    tasks[newIndex] = todoTasks[index];

    await PreferencesManager().setString(StorageKey.tasks, jsonEncode(tasks));
    _loadTasks();
  }

  void doneCompleteTask(bool? value, int? index) async {
    if (index == null) return;
    completedTasks[index].isDone = value ?? false;

    final int newIndex = tasks.indexWhere(
      (e) => e.id == completedTasks[index].id,
    );
    tasks[newIndex] = completedTasks[index];

    await PreferencesManager().setString(StorageKey.tasks, jsonEncode(tasks));

    _loadTasks();
  }

  void doneHighPriorityTask(bool? value,int?index)async{
    if (index == null) return;
    highPriorityTasks[index].isDone = value ?? false;

    final int newIndex = tasks.indexWhere(
          (e) => e.id == highPriorityTasks[index].id,
    );
    tasks[newIndex] = highPriorityTasks[index];

    await PreferencesManager().setString(StorageKey.tasks, jsonEncode(tasks));
    _loadTasks();
  }


  void deleteTask(int? id) async {
    if (id == null) return;

    tasks.removeWhere((e) => e.id == id);

    todoTasks.removeWhere((task) => task.id == id);
    completedTasks.removeWhere((task) => task.id == id);
    highPriorityTasks.removeWhere((task) => task.id == id);
    calculatePercent();

    await PreferencesManager().setString(StorageKey.tasks, jsonEncode(tasks));

    notifyListeners();
  }
  void calculatePercent() {
    totalTasks = tasks.length;
    totalDoneTasks = tasks.where((e) => e.isDone).length;
    precent = totalTasks == 0 ? 0 : totalDoneTasks / totalTasks;
    notifyListeners();
  }

}
