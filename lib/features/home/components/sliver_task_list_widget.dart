import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/components/task_item_widget.dart';

import '../../tasks/controller/tasks_controller.dart';



class SliverTaskListWidget extends StatelessWidget {
  const SliverTaskListWidget({
    super.key,

  });



  @override
  Widget build(BuildContext context) {
    return Consumer<TasksController>(
      builder: (BuildContext context, TasksController controller, Widget? child) {
        final tasksList=controller.tasks;
        return tasksList.isEmpty
            ? SliverToBoxAdapter(
          child: Center(
            child: Text(
              "No Data",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        )
            : SliverPadding(
          padding: EdgeInsetsGeometry.only(bottom: 80),
          sliver: SliverList.separated(
            itemCount: tasksList.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: TaskItemWidget(
                  model: tasksList[index],
                  onChanged: (bool? value) {
                    controller.doneTask(value, index);
                  },
                  onDelete: (int? id) {
                    controller.deleteTask(id);
                  },
                  onEdit: (){
                    controller.init();
                  },
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: 4);
            },
          ),
        );
      },
    );
  }
}
