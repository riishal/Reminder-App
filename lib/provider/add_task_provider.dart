import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/constants/alert_message.dart';

import '../core/constents.dart';
import '../model/todo_model.dart';
import '../service/notification_helper.dart';
import '../service/todo_service.dart';
// 13

class AddTaskProvider extends ChangeNotifier {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  TaskState initialTaskState = TaskState.upcoming;
  final format = DateFormat.yMd();
  int radioValue = 0;
  String dateValue = "dd/MM/yyyy";
  String timeValue = "hh:mma";
  String category = "Other";

  String checkTaskState(TaskState state) {
    switch (state) {
      case TaskState.upcoming:
        return "upcoming";
      case TaskState.finished:
        return "finished";

      default:
        return "";
    }
  }

  void setRadioValue(groupValue, context) {
    radioValue = groupValue;
    switch (groupValue) {
      case 1:
        category = "Learn";
        break;
      case 2:
        category = "Work";
        break;
      case 3:
        category = "Genarel";
        break;
      default:
        category;
        break;
    }
    setDateAndTime(context);
    notifyListeners();
  }

  void updateRadioValue(groupValue) {
    switch (groupValue) {
      case "Learn":
        radioValue = 1;

        break;
      case "Work":
        radioValue = 2;
        break;
      case "Genarel":
        radioValue = 3;
        break;
      default:
        radioValue;
        break;
    }

    notifyListeners();
  }

  setDateAndTime(context) {
    final format = DateFormat.yMd();
    if (dateValue == "dd/MM/yyyy" && timeValue == "hh:mma") {
      dateValue = format.format(DateTime.now());
      timeValue = DateFormat('hh:mma').format(DateTime.now());
      print('////////// time value: $timeValue');
    }
    notifyListeners();
  }

  void setDate(BuildContext context) async {
    final getValue = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2025));

    if (getValue != null) {
      dateValue = format.format(getValue);
    } else {
      dateValue = format.format(DateTime.now());
    }

    notifyListeners();
  }

  void setTime(BuildContext context) async {
    final getTime = await showTimePicker(
        context: context, initialTime: TimeOfDay.fromDateTime(DateTime.now()));
    if (getTime != null) {
      timeValue = getTime.format(context);
      print('////////// time value: $timeValue');
    } else {
      timeValue = DateFormat('hh:mma').format(DateTime.now());
      print('////////// time value: $timeValue');
    }
    notifyListeners();
  }

  addTask(context) {
    setDateAndTime(context);
    String taskState = checkTaskState(initialTaskState);
    String date = dateValue;
    String time = timeValue;
    String dateTime = '$date ${time.split(' ').join()}';
    print('NewDate: $date ${time.split(' ').join()}');
    DateTime newDate = DateFormat("dd/MM/yyyy hh:mma").parse(dateTime);
    print('NewDate: $newDate');

    if (newDate.isAfter(DateTime.now())) {
      taskState = 'upcoming';
    } else {
      taskState = 'finished';
    }
    TodoService().addNewTask(TodoModel(
        taskState: taskState,
        isDone: false,
        titleTask: titleController.text,
        description: descriptionController.text,
        category: category,
        dateTask: dateValue,
        timeTask: timeValue));

    // print('/////////date: $dateValue, time: $timeValue');
    LocalNotifications.showScheduleNotification(
        title: "Your Task time is right now!",
        body: titleController.text,
        payload: descriptionController.text,
        date: dateValue,
        time: timeValue);
    showToast("Task added successfully", Colors.blue.shade400);
  }

  updateAllTask(context, String docId) {
    // print(object);
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();
    if (title == "" || description == "") {
      AlertMessage.showAlertDialog(
          context, "Not Updated", "Please Update all the fields");
    } else {
      setDateAndTime(context);
      String taskState = checkTaskState(initialTaskState);
      TodoService().updateAllTask(
          TodoModel(
              taskState: taskState,
              isDone: false,
              titleTask: titleController.text,
              description: descriptionController.text,
              category: category,
              dateTask: dateValue,
              timeTask: timeValue),
          docId);
      // print('/////////date: $dateValue, time: $timeValue');
      LocalNotifications.showScheduleNotification(
          title: "Your Task time is right now!",
          body: titleController.text,
          payload: descriptionController.text,
          date: dateValue,
          time: timeValue);
      showToast("Task has Updated", Colors.amber.shade700);
      clear(context);
    }
  }

  void clear(context) {
    titleController.clear();
    descriptionController.clear();
    radioValue = 0;
    dateValue = "dd/mm/yy";
    timeValue = "hh : mm";
    category = "Other";

    Navigator.pop(context);
  }

  updateTask(String docId, bool value) {
    TodoService().updateTask(docId, value);
  }

  void deleteTask(docId) {
    TodoService().deleteTask(docId);
  }

  void showToast(String msg, Color color) {
    Fluttertoast.showToast(
        msg: msg, backgroundColor: color, textColor: Colors.white);
  }

  void checkValues(context) {
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();
    if (title == "" || description == "") {
      AlertMessage.showAlertDialog(
          context, "Incomplited", "Please fill all the fields");
    } else {
      //login
      addTask(context);
      clear(context);
    }
  }

  chckConditions(String time, String date) {
    var currtime = TimeOfDay.now();
    var timecurr =
        '${currtime.hour.toString().padLeft(2, '0')}:${currtime.minute.toString().padLeft(2, '0')}';
    var currentDate = format.format(DateTime.now());
    if (date == currentDate && time == timecurr) {
      // print("Notification");
    }
  }
}
