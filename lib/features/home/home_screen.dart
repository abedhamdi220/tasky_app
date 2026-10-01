import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/features/home/home_controller.dart';
import 'package:tasky/features/add_task/add_task_screen.dart';
import 'package:tasky/features/home/components/achieved_tasks_widget.dart';
import 'package:tasky/features/home/components/high_priority_tasks_widget.dart';
import '../../core/widgets/custom_svg_picture.dart';
import 'components/sliver_task_list_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      create: (_) => HomeController()..init(),
      child: Scaffold(
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
                          Selector<HomeController, String?>(
                            builder:
                                (
                                  BuildContext context,
                                  String? userImagePath,
                                  Widget? child,
                                ) {
                                  return CircleAvatar(
                                    backgroundImage: userImagePath == null
                                        ? AssetImage(
                                            "assets/images/c2c02c46fb3953f5c181fc6958c9be600a55b220.png",
                                          )
                                        : FileImage(File(userImagePath)),
                                    backgroundColor: Colors.transparent,
                                  );
                                },
                            selector:
                                (
                                  BuildContext context,
                                  HomeController controller,
                                ) {
                                  return controller.userImagePath;
                                },
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Selector<HomeController, String?>(
                                builder:
                                    (
                                      BuildContext context,
                                      String? userName,
                                      Widget? child,
                                    ) {
                                      return Text(
                                        "Good Evening ,$userName",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                      );
                                    },
                                selector:
                                    (
                                      BuildContext context,
                                      HomeController controller,
                                    ) {
                                      return controller.userName;
                                    },
                              ),
                              Selector<HomeController, String?>(
                                builder:
                                    (
                                      BuildContext context,
                                      String? motivationQuote,
                                      Widget? child,
                                    ) {
                                      return Text(
                                        motivationQuote ??
                                            "One task at a time. One step closer.",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleSmall,
                                      );
                                    },
                                selector:
                                    (
                                      BuildContext context,
                                      HomeController controller,
                                    ) {
                                      return controller.motivationQuote;
                                    },
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Yuhuu,Your Work Is",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      Row(
                        children: [
                          Text(
                            "almost done !",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          CustomSvgPicture.withoutColor(
                            path: "assets/images/waving-hand.svg",
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      AchievedTasksWidget(),
                      SizedBox(height: 8),
                      HighPriorityTasksWidget(),
                      Padding(
                        padding: const EdgeInsets.only(top: 26, bottom: 16),
                        child: Text(
                          "My Tasks",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ],
                  ),
                ),
                SliverTaskListWidget(),
              ],
            ),
          ),
        ),
        floatingActionButton: SizedBox(
          height: 44,
          child: Builder(

            builder: (BuildContext controllerContext) {
              return FloatingActionButton.extended(
                onPressed: () async {
                  final bool? result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return AddTaskScreen();
                      },
                    ),
                  );
                  if (result != null && result) {
                    controllerContext.read<HomeController>().loadTask();
                  }
                },
                label: Text("Add New Task"),
                icon: Icon(Icons.add),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              );
            },

          ),
        ),
      ),
    );
  }
}
