import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:todo/UI/size_config.dart';
import 'package:todo/UI/widgets/button.dart';
import 'package:todo/UI/widgets/task_tile.dart';

import 'package:todo/services/theme_services.dart';
import 'package:get/get.dart';
import 'package:todo/utils/theme.dart';

import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import 'add_task_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    taskController.getTasks();
  }

  DateTime selectedDate = DateTime.now();
  final TaskController taskController = Get.put(TaskController());
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    Get.put(ThemeServices());

    return Scaffold(
      appBar: AppBar(
        leading: GetBuilder<ThemeServices>(
          builder: (controller) => IconButton(
            icon: controller.loadThemeFromBox()
                ? const Icon(Icons.wb_sunny_outlined)
                : const Icon(Icons.nightlight_round_outlined),
            onPressed: () {
              controller.switchTheme();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
          padding: const EdgeInsets.only(left: 10, top: 8, right: 10),
          width: SizeConfig.screenWidth,
          child: Column(
            children: [
              addTaskPar(),
              const SizedBox(
                height: 10,
              ),
              addDatePar(),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: showTasks(),
              ),
            ],
          )),
    );
  }

  addTaskPar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMMMMd().format(DateTime.now()),
              style: subHeadingStyle.copyWith(
                  color: context.isDarkMode ? Colors.white : Colors.black),
            ),
            Text(
              'Today',
              style: headingStyle.copyWith(
                  color: context.isDarkMode ? Colors.white : Colors.black),
            )
          ],
        ),
        AButton(
          label: '+ Add Task',
          onTap: () async {
            await Get.to(() => const AddTaskPage());
            taskController.getTasks();
          },
        )
      ],
    );
  }

  addDatePar() {
    return Container(
      child: DatePicker(
        DateTime.now(),
        width: 70,
        height: 100,
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        initialSelectedDate: DateTime.now(),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        onDateChange: (newDate) {
          setState(() {
            selectedDate = newDate;
          });
        },
      ),
    );
  }

  showTasks() {
    return Obx(
      () {
        if (taskController.taskList.isEmpty) {
          return noTaskMsg();
        } else {
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.builder(
              itemCount: taskController.taskList.length,
              scrollDirection: SizeConfig.orientation == Orientation.landscape
                  ? Axis.horizontal
                  : Axis.vertical,
              itemBuilder: (context, index) {
                var task = taskController.taskList[index];
                if (task.repeat == 'Daily' ||
                    // ignore: unrelated_type_equality_checks
                    task.date == DateFormat.yMd().format(selectedDate) ||
                    (task.repeat == 'weekly' &&
                        selectedDate
                                    .difference(
                                        DateFormat.yMd().parse(task.date!))
                                    .inDays %
                                7 ==
                            0) ||
                    (task.repeat == 'monthly' &&
                        DateFormat.yMd().parse(task.date!).day ==
                            selectedDate.day)) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 1000),
                    child: SlideAnimation(
                      horizontalOffset: 300,
                      child: FadeInAnimation(
                        child: InkWell(
                          onTap: () {
                            showButtomSheet(
                              context,
                              task,
                            );
                          },
                          child: TaskTile(
                            task: task,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          );
        }
      },
    );
  }

  noTaskMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: SingleChildScrollView(
              child: Wrap(
                direction: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(height: 6)
                      : const SizedBox(height: 100),
                  SvgPicture.asset(
                    'assets/images/note.svg',
                    semanticsLabel: 'Task',
                    color: context.isDarkMode ? Colors.white : Colors.black,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  Text(
                      'You Don\'t have any tasks yet! \n Add new tasks to make your day productive',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color:
                              context.isDarkMode ? Colors.white : Colors.black,
                          fontSize: 16))
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  showButtomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 4),
          width: SizeConfig.screenWidth,
          height: (SizeConfig.orientation == Orientation.landscape)
              ? (task.isCompleted == 1
                  ? SizeConfig.screenHeight * 0.6
                  : SizeConfig.screenHeight * 0.8)
              : (task.isCompleted == 1
                  ? SizeConfig.screenHeight * 0.30
                  : SizeConfig.screenHeight * 0.33),
          color: context.isDarkMode ? darkHeaderClr : Colors.white,
          child: Column(
            children: [
              Flexible(
                child: Container(
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: context.isDarkMode
                          ? Colors.grey[600]
                          : Colors.grey[300]),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              task.isCompleted == 1
                  ? Container()
                  : builsButtomSheet(
                      label: 'Task Completed',
                      onTap: () {
                        taskController.markTaskCompleted(task.id!);
                        Get.back();
                      },
                      clr: primaryClr),
              builsButtomSheet(
                label: 'Delete ',
                onTap: () {
                  setState(() {
                    taskController.deldeTask(task);
                    Get.back();
                  });
                },
                clr: pinkClr,
              ),
              Divider(
                color: context.isDarkMode ? Colors.grey : darkGreyClr,
                endIndent: 20,
                indent: 20,
              ),
              builsButtomSheet(
                  label: 'Cancel',
                  onTap: () {
                    Get.back();
                  },
                  clr: primaryClr),
            ],
          ),
        ),
      ),
    );
  }

  builsButtomSheet(
      {required String label,
      required Function() onTap,
      required Color clr,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        height: 64,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? context.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? titleStyle
                : titleStyle.copyWith(
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> onRefresh() async {
    taskController.getTasks();
  }
}
