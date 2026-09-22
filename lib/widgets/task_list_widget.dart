import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/core/widgets/custom_check_box.dart';
import 'package:tasky/models/task_model.dart';
import 'package:tasky/widgets/task_item_widget.dart';

class TaskListWidget extends StatelessWidget {
  const TaskListWidget({
    super.key,
    required this.tasks,
    required this.onTap,
    required this.emptyMessage,
    required this.onDelete,
    required this.onEdit,
  });

  final List<TaskModel> tasks;
  final Function(bool?, int?) onTap;
  final String emptyMessage;
  final Function(int?) onDelete;
  final Function onEdit;

  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty
        ? Center(
            child: Text(
              emptyMessage,
              style: Theme.of(context).textTheme.displaySmall,
            ),
          )
        : ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: 60),
            itemCount: tasks.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: TaskItemWidget(
                  model: tasks[index],
                  onChanged: (bool? value) {
                    onTap(value, index);
                  },
                  onDelete: (int? id) {
                    onDelete(id);
                  },
                  onEdit: () {
                    onEdit();
                  },
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: 4);
            },
          );
  }
}
