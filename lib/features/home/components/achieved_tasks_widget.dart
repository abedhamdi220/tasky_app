import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/features/home/home_controller.dart';

import '../../../core/theme/theme_controller.dart';

class AchievedTasksWidget extends StatelessWidget {
  const AchievedTasksWidget({
    super.key,

  });


  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(

      builder: (BuildContext context,HomeController controller, Widget? child) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.primaryContainer,
            border: Border.all(
              color: !ThemeController.isDark()
                  ? Color(0xFFD1DAD6)
                  : Colors.transparent,
            ),
          ),
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Achieved Tasks",
                    style:
                    Theme.of(context).textTheme.titleMedium,

                  ),
                  SizedBox(height: 4),
                  Text(
                    "${controller.totalDoneTasks} Out of ${controller.totalTasks} Done",
                    style:Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Transform.rotate(
                    angle: -pi / 2,
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: CircularProgressIndicator(
                        value: controller.precent,
                        backgroundColor: Color(0xFF6D6D6D),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF15B86C),
                        ),
                        strokeWidth: 4,
                      ),
                    ),
                  ),
                  Text(
                    "${((controller.precent * 100).toInt())} %",
                    style:Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ],
          ),
        );
      },

    );
  }
}
