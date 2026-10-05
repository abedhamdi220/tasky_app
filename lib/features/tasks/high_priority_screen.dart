import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/features/tasks/controller/tasks_controller.dart';
import '../../core/components/task_list_widget.dart';

class HighPriorityScreen extends StatelessWidget {
  const HighPriorityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<TasksController>();
    return Scaffold(
      appBar: AppBar(title: Text("High Priority Tasks")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<TasksController>(
          builder: (BuildContext context, value, Widget? child) {
            return TaskListWidget(
              emptyMessage: "No Tasks Found",
              tasks: value.highPriorityTasks,
              onTap: (value, index) async {
                controller.doneHighPriorityTask(value, index);
              },
              onDelete: (int? id) {
                controller.deleteTask(id);
              },
              onEdit: () {
                controller.init();
              },
            );
          },
        ),
      ),
    );
  }
}
