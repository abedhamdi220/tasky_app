import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/components/task_list_widget.dart';
import 'package:tasky/features/tasks/controller/tasks_controller.dart';


class TodoTasksScreen extends StatelessWidget {
  const TodoTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =context.read<TasksController>();
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
            child: Consumer<TasksController>(
              builder: (BuildContext context, value, Widget? child) {
                return TaskListWidget(
                  emptyMessage: "No Tasks Found",
                  tasks: value.todoTasks,
                  onTap: (value, index) async {
                    controller.doneTodoTask(value, index);
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
        ),
      ],
    );

  }
}
