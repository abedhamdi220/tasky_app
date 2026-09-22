import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/core/enums/task_item_actions_enums.dart';
import 'package:tasky/core/widgets/custom_text_form_field.dart';

import '../core/services/preferences_manager.dart';
import '../core/theme/theme_controller.dart';
import '../core/widgets/custom_check_box.dart';
import '../models/task_model.dart';

class TaskItemWidget extends StatelessWidget {
  TaskItemWidget({
    super.key,
    required this.model,
    required this.onChanged,
    required this.onDelete,
    required this.onEdit,
  });

  final TaskModel model;
  final Function(bool?) onChanged;
  final Function(int? value) onDelete;
  final Function onEdit;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.primaryContainer,
        border: Border.all(
          color: !ThemeController.isDark()
              ? Color(0xFFD1DAD6)
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 8),
          CustomCheckBox(
            value: model.isDone,
            onChanged: (bool? value) => onChanged(value),
          ),

          SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.taskName,
                  style: model.isDone
                      ? Theme.of(context).textTheme.titleLarge
                      : Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                ),
                Text(
                  model.taskDescription,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
          PopupMenuButton<TaskItemActionsEnums>(
            onSelected: (value) async {
              switch (value) {
                case TaskItemActionsEnums.markAsRead:
                  onChanged(!model.isDone);
                  break;
                case TaskItemActionsEnums.edit:
                  final result =await _showButtonSheet(context, model);
                  if(result==true){
                    onEdit();
                  }
                 print(result);

                  break;
                case TaskItemActionsEnums.delete:
                  await _showAlertDialog(context);
              }
            },
            icon: Icon(
              Icons.more_vert,
              color: ThemeController.isDark()
                  ? (model.isDone ? Color(0xFFA0A0A0) : Color(0xFFC6C6C6))
                  : (model.isDone ? Color(0xFF6A6A6A) : Color(0xFF3A4640)),
            ),
            itemBuilder: (context) => TaskItemActionsEnums.values
                .map((e) => PopupMenuItem(value: e, child: Text(e.name)))
                .toList(),
          ),
        ],
      ),
    );
  }

  Future<String?> _showAlertDialog(context) {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Text("Are you sure you want to delete this task!")],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                onDelete(model.id);
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

 Future<bool?> _showButtonSheet(BuildContext context, TaskModel model) async {
    final TextEditingController taskNameController = TextEditingController(
      text: model.taskName,
    );
    bool isHighPriority = model.isHighPriority;
    final TextEditingController taskDescriptionController =
        TextEditingController(text: model.taskDescription);

    final GlobalKey<FormState> key = GlobalKey<FormState>();

    return showModalBottomSheet<bool>(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      builder: (context) {
        return SafeArea(
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Form(
                  key: key,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 30),
                              CustomTextFormField(
                                controller: taskNameController,
                                hintText: "Finish Ui design for login screen",
                                validator: (String? value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Please Enter Task Name";
                                  } else {
                                    return null;
                                  }
                                },
                                title: "Task Name",
                              ),
                              SizedBox(height: 20),
                              CustomTextFormField(
                                controller: taskDescriptionController,
                                maxLine: 5,
                                hintText:
                                    "Finish onboarding UI and hand off to devs by Thursday.",
                                title: "Task Description",
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "High Priority",
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Switch(
                                    value: isHighPriority,
                                    onChanged: (bool value) {
                                      setState(() {
                                        isHighPriority = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          fixedSize: Size(MediaQuery.sizeOf(context).width, 40),
                        ),
                        onPressed: () async {
                          if (key.currentState?.validate() ?? false) {
                            final taskJson = PreferencesManager().getString(
                              "tasks",
                            );
                            List<dynamic> listTasks = [];
                            if (taskJson != null) {
                              listTasks = jsonDecode(taskJson);
                            }

                            final newModel = TaskModel(
                              id: model.id,
                              taskName: taskNameController.text,
                              taskDescription: taskDescriptionController.text,
                              isHighPriority: isHighPriority,
                              isDone: model.isDone,
                            );
                            final item = listTasks.firstWhere(
                              (e) => e['id'] == model.id,
                            );
                            final index = listTasks.indexOf(item);
                            listTasks[index] = newModel.toMap();
                            final taskEncode = jsonEncode(listTasks);
                            await PreferencesManager().setString("tasks", taskEncode);

                            Navigator.of(context).pop(true);
                          }
                        },
                        label: Text("Edit Task"),
                        icon: Icon(Icons.edit),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
