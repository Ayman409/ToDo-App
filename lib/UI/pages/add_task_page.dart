import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/UI/widgets/button.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';

import '../../utils/theme.dart';
import '../widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController taskController = Get.put(TaskController());
  final TextEditingController textController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String starttime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String endtime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int selectedColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
                taskController.getTasks();
              },
              icon: Icon(Icons.arrow_back_ios_new_outlined))),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Add Task',
                style: headingStyle,
              ),
              AInputField(
                title: 'Title',
                hint: 'Enter title here',
                controller: textController,
              ),
              const SizedBox(
                height: 10,
              ),
              AInputField(
                title: 'Note',
                hint: 'Enter note here',
                controller: noteController,
              ),
              const SizedBox(
                height: 10,
              ),
              AInputField(
                title: 'Date',
                hint: DateFormat.yMd().format(selectedDate),
                widget: IconButton(
                  onPressed: () => getDateFromUser(),
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: AInputField(
                      title: 'Start time',
                      hint: starttime,
                      widget: IconButton(
                        onPressed: () => getTimeFromUser(isStartTime: true),
                        icon: const Icon(
                          Icons.access_time_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: AInputField(
                      title: 'End time',
                      hint: endtime,
                      widget: IconButton(
                        onPressed: () => getTimeFromUser(isStartTime: false),
                        icon: const Icon(
                          Icons.access_time_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              AInputField(
                title: 'Remind',
                hint: '$selectedRemind mintutes early',
                widget: DropdownButton(
                  borderRadius: BorderRadius.circular(10),
                  items: remindList
                      .map<DropdownMenuItem<String>>(
                        (int value) => DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text(
                            textAlign: TextAlign.center,
                            '$value',
                            style: TextStyle(
                                color: context.isDarkMode
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      )
                      .toList(),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 3,
                  underline: Container(
                    height: 0,
                  ),
                  style: subTitleStyle,
                  onChanged: (String? newvalue) {
                    setState(() {
                      selectedRemind = int.parse(newvalue!);
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              AInputField(
                title: 'Repeat',
                hint: selectedRepeat,
                widget: DropdownButton(
                  borderRadius: BorderRadius.circular(10),
                  items: repeatList
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                  color: context.isDarkMode
                                      ? Colors.white
                                      : Colors.black),
                            )),
                      )
                      .toList(),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 3,
                  underline: Container(
                    height: 0,
                  ),
                  style: subTitleStyle,
                  onChanged: (String? newvalue) {
                    setState(() {
                      selectedRepeat = newvalue!;
                    });
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Color',
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Wrap(
                          children: List.generate(
                            3,
                            (index) => InkWell(
                              onTap: () {
                                setState(() {
                                  selectedColor = index;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: CircleAvatar(
                                  backgroundColor: index == 0
                                      ? primaryClr
                                      : index == 1
                                          ? pinkClr
                                          : orangeClr,
                                  radius: 14,
                                  child: selectedColor == index
                                      ? const Icon(
                                          Icons.done,
                                          size: 16,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              AButton(
                label: 'Add Task',
                onTap: () {
                  validation();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  validation() {
    if (textController.text.isNotEmpty && noteController.text.isNotEmpty) {
      addTaskToDb();
      Get.back();
    } else if (textController.text.isEmpty || noteController.text.isEmpty) {
      Get.snackbar(
        'Required',
        'All Fileds are required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: primaryClr,
        icon: const Icon(
          Icons.warning_amber_outlined,
          color: Colors.red,
        ),
      );
    } else {
      print('########### SOMETHING BAD HABBEND ############');
    }
  }

  addTaskToDb() async {
    int value = await taskController.addTask(
      task: Task(
        title: textController.text,
        note: noteController.text,
        isCompleted: 0,
        date: DateFormat.yMd().format(selectedDate),
        startTime: starttime,
        endTime: endtime,
        color: selectedColor,
        remind: selectedRemind,
        repeat: selectedRepeat,
      ),
    );
    print('$value');
  }

  getDateFromUser() async {
    DateTime? pickesDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2040));
    if (pickesDate != null) {
      setState(() {
        selectedDate = pickesDate;
      });
    } else {
      setState(() {
        selectedDate = DateTime.now();
      });
    }
  }

  getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
              DateTime.now().add(
                const Duration(minutes: 15),
              ),
            ),
    );
    String formattedTime = pickedTime!.format(context);
    if (isStartTime) {
      setState(() {
        starttime = formattedTime;
      });
    }
    if (!isStartTime) {
      setState(() {
        endtime = formattedTime;
      });
    } else {
      print('canceled');
    }
  }
}
