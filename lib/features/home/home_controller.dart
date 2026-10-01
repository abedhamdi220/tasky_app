import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/constants/storage_key.dart';
import '../../core/services/preferences_manager.dart';
import '../../models/task_model.dart';

class HomeController with ChangeNotifier {
  String? userName;
  bool isCheck = false;
  List<TaskModel> tasks = [];
  int totalTasks = 0;
  int totalDoneTasks = 0;
  double precent = 0;
  String? motivationQuote;
  String? userImagePath;


  void init() {
    loadUserData();
    loadTask();
  }

  void loadUserData() async {
    userImagePath = PreferencesManager().getString(StorageKey.userImagePath);
    userName = PreferencesManager().getString(StorageKey.username);
    motivationQuote = PreferencesManager().getString(
      StorageKey.motivationQuote,
    );
    notifyListeners();
  }

  void doneTask(bool? value, int? index) async {
    tasks[index!].isDone = value ?? false;
    calculatePercent();

    final updatedTask = tasks.map((element) => element.toMap()).toList();
    await PreferencesManager().setString('tasks', jsonEncode(updatedTask));
    notifyListeners();
  }

  void deleteTask(int? id) async {
    if (id == null) return;
    tasks.removeWhere((task) => task.id == id);
    calculatePercent();

    //make shared method
    final updatedTask = tasks.map((element) => element.toMap()).toList();
    await PreferencesManager().setString('tasks', jsonEncode(updatedTask));
    notifyListeners();
  }

  void loadTask() async {
    final finalTask = PreferencesManager().getString(StorageKey.tasks);

    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;

      tasks = taskAfterDecode
          .map((element) => TaskModel.fromJson(element))
          .toList();
      calculatePercent();
    }
    notifyListeners();
  }

  void calculatePercent() {
    totalTasks = tasks.length;
    totalDoneTasks = tasks.where((e) => e.isDone).length;
    precent = totalTasks == 0 ? 0 : totalDoneTasks / totalTasks;
    notifyListeners();
  }
}
