import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/widgets/custom_text_form_field.dart';
import 'package:tasky/features/add_task/add_task_controller.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ChangeNotifierProvider<AddTaskController>(
        create: (_) => AddTaskController(),
        builder: (context, _) {
          final AddTaskController controller = context
              .read<AddTaskController>();
          return Scaffold(
            appBar: AppBar(title: Text("New Task")),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Form(
                key: controller.key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextFormField(
                              controller: controller.taskNameController,
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
                              controller: controller.taskDescriptionController,
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

                                Consumer<AddTaskController>(
                                  builder:
                                      (
                                        BuildContext context,
                                        AddTaskController value,
                                        Widget? child,
                                      ) {
                                        return Switch(
                                          value: controller.isHighPriority,
                                          onChanged: (bool value) {
                                            controller.toggle(value);
                                          },
                                        );
                                      },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Consumer(
                      builder: (BuildContext context, value, Widget? child) {
                        return ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            fixedSize: Size(
                              MediaQuery.sizeOf(context).width,
                              40,
                            ),
                          ),
                          onPressed: () {
                            controller.addTask(context);
                          },
                          label: Text("Add Task"),
                          icon: Icon(Icons.add),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
