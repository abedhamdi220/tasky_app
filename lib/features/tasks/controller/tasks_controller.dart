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
      _loadData();
      _calculatePercent();
    }
    isLoading = false;
    notifyListeners();
  }

  void _loadData() {
    todoTasks = tasks.where((element) => !element.isDone).toList();
    completedTasks = tasks.where((element) => element.isDone).toList();
    highPriorityTasks = tasks
        .where(((element) => element.isHighPriority))
        .toList()
        .reversed
        .toList();
  }

  void doneTask(bool? value, int id) async {
    final index = tasks.indexWhere((e) => e.id == id);

    tasks[index].isDone = value ?? false;
    _loadData();
    _calculatePercent();

    final updatedTask = tasks.map((e) => e.toJson()).toList();
    await PreferencesManager().setString(
      StorageKey.tasks,
      jsonEncode(updatedTask),
    );

    _loadTasks();
  }

  void deleteTask(int? id) async {
    if (id == null) return;

    tasks.removeWhere((e) => e.id == id);

    _loadData();
    _calculatePercent();
    await PreferencesManager().setString(StorageKey.tasks, jsonEncode(tasks));

    notifyListeners();
  }

  void _calculatePercent() {
    totalTasks = tasks.length;
    totalDoneTasks = tasks.where((e) => e.isDone).length;
    precent = totalTasks == 0 ? 0 : totalDoneTasks / totalTasks;
    notifyListeners();
  }
}
