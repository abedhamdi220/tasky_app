import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/core/widgets/custom_text_form_field.dart';
import 'package:tasky/models/task_model.dart';

import '../../core/constants/storage_key.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTaskScreen> {
  final TextEditingController taskNameController = TextEditingController();

  final TextEditingController taskDescriptionController =
  TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  bool isHighPriority = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("New Task")),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        CustomTextFormField(
                          controller: taskNameController,
                          hintText: "Finish Ui design for login screen",
                          validator: (String? value) {
                            if (value == null || value
                                .trim()
                                .isEmpty) {
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "High Priority",
                              style: TextStyle(
                                color: Color(0xFFFFFCFC),
                                fontSize: 16,
                              ),
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
                    fixedSize: Size(MediaQuery
                        .sizeOf(context)
                        .width, 40),
                  ),
                  onPressed: () async {
                    if (_key.currentState?.validate() ?? false) {
                      final taskJson = PreferencesManager().getString(StorageKey.tasks);
                      List<dynamic> listTasks = [];
                      if (taskJson != null) {
                        listTasks = jsonDecode(taskJson);
                      }

                      final model = TaskModel(
                        id: listTasks.length + 1,
                        taskName: taskNameController.text,
                        taskDescription: taskDescriptionController.text,
                        isHighPriority: isHighPriority,
                      );

                      listTasks.add(model.toMap());
                      final taskEncode = jsonEncode(listTasks);
                      await PreferencesManager().setString(StorageKey.tasks, taskEncode);

                      Navigator.of(context).pop(true);
                    }
                  },
                  label: Text("Add Task"),
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
