import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasky/models/task_model.dart';
import 'package:tasky/screens/add_task_screen.dart';
import 'package:tasky/widgets/achieved_tasks_widget.dart';
import 'package:tasky/widgets/high_priority_tasks_widget.dart';
import '../core/services/preferences_manager.dart';
import '../core/widgets/custom_svg_picture.dart';
import '../widgets/sliver_task_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName;
  bool isCheck = false;
  List<TaskModel> tasks = [];
  int totalTasks = 0;
  int totalDoneTasks = 0;
  double precent = 0;
  String? motivationQuote;
  String? userImagePath;

  @override
  void initState() {
    super.initState();

    _loadUserName();
    _loadTask();
  }

  void _loadUserName() async {
    setState(() {
      userImagePath = PreferencesManager().getString("image_path");
      userName = PreferencesManager().getString("userName");
      motivationQuote = PreferencesManager().getString("motivation_quote");
    });
  }

  _doneTask(bool? value, int? index) async {
    setState(() {
      tasks[index!].isDone = value ?? false;
      _calculatePercent();
    });
    final updatedTask = tasks.map((element) => element.toMap()).toList();
    await PreferencesManager().setString('tasks', jsonEncode(updatedTask));
  }

  _deleteTask(int? id) async {
    if (id == null) return;
    setState(() {
      tasks.removeWhere((task) => task.id == id);
      _calculatePercent();
    });
    //make shared method
    final updatedTask = tasks.map((element) => element.toMap()).toList();
    await PreferencesManager().setString('tasks', jsonEncode(updatedTask));
  }

  void _loadTask() async {
    final finalTask = PreferencesManager().getString("tasks");

    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;

      setState(() {
        tasks = taskAfterDecode
            .map((element) => TaskModel.fromJson(element))
            .toList();
        _calculatePercent();
      });
    }
  }

  _calculatePercent() {
    totalTasks = tasks.length;
    totalDoneTasks = tasks
        .where((e) => e.isDone)
        .length;
    precent = totalTasks == 0 ? 0 : totalDoneTasks / totalTasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: userImagePath == null
                              ? AssetImage(
                            "assets/images/c2c02c46fb3953f5c181fc6958c9be600a55b220.png",
                          )
                              : FileImage(File(userImagePath!)),
                          backgroundColor: Colors.transparent,
                        ),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Good Evening ,$userName",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium,
                            ),
                            Text(
                              motivationQuote ??
                                  "One task at a time. One step closer.",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .titleSmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Yuhuu,Your Work Is",
                      style: Theme
                          .of(context)
                          .textTheme
                          .displayLarge,
                    ),
                    Row(
                      children: [
                        Text(
                          "almost done !",
                          style: Theme
                              .of(context)
                              .textTheme
                              .displayLarge,
                        ),
                        CustomSvgPicture.withoutColor(
                          path: "assets/images/waving-hand.svg",
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    AchievedTasksWidget(
                      totalTasks: totalTasks,
                      totalDoneTasks: totalDoneTasks,
                      precent: precent,
                    ),
                    SizedBox(height: 8),
                    HighPriorityTasksWidget(
                      refresh: () {
                        _loadTask();
                      },
                      tasks: tasks,
                      onTap: (bool? value, int? index) {
                        _doneTask(value, index);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 26, bottom: 16),
                      child: Text(
                        "My Tasks",
                        style: Theme
                            .of(context)
                            .textTheme
                            .labelLarge,
                      ),
                    ),
                  ],
                ),
              ),
              SliverTaskListWidget(
                tasks: tasks,
                emptyMessage: "No Data",
                onTap: (bool? value, int? index) {
                  _doneTask(value, index);
                },
                onDelete: (int? id) {
                  _deleteTask(id);
                },
                onEdit: () {
                  _loadTask();
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        height: 44,
        child: FloatingActionButton.extended(
          onPressed: () async {
            final bool? result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return AddTaskScreen();
                },
              ),
            );
            if (result != null && result) _loadTask();
          },
          label: Text("Add New Task"),
          icon: Icon(Icons.add),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
