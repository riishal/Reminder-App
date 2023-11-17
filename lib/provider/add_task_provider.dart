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

//date time format changing
  setDateAndTime(context) {
    final format = DateFormat.yMd();
    if (dateValue == "dd/MM/yyyy" && timeValue == "hh:mma") {
      dateValue = format.format(DateTime.now());
      timeValue = DateFormat('hh:mma').format(DateTime.now());
      print('////////// time value: $timeValue');
    }
    notifyListeners();
  }

  setDate(BuildContext context) async {
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

//adding firestore database
  addTask(context) {
    setDateAndTime(context);
    String taskState = checkTaskState(initialTaskState);
    var date = dateValue.split('/').toList();
    var dateExp = '${date[1]}/${date[0]}/${date[2]}';
    String time = timeValue;
    String dateTime = '$dateExp ${time.split(' ').join()}';
    print('NewDate: $dateExp ${time.split(' ').join()}');
    DateTime newDate = DateFormat("dd/MM/yyyy hh:mma").parse(dateTime);
    print('Date: ${DateTime.now()}');
    print('newDate: $newDate');

    if (newDate.isAfter(DateTime.now())) {
      taskState =
          'upcoming'; // 2023-11-13 14:30:00.579496 2023-12-11 14:26:00.000
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

    //5 minutes before notification
    //5 minutes before notification
    LocalNotifications.showScheduleNotification(
        minute: 5,
        title: "Get ready! ${titleController.text} is scheduled soon.",
        body:
            "This is a friendly reminder for your task Scheduled Time:$timeValue",
        payload: descriptionController.text,
        date: dateValue,
        time: timeValue);
    //Current time notification
    LocalNotifications.showScheduleNotification(
        minute: 0,
        title: "Your Time is Now!",
        body: "Time is ticking! Do your ${titleController.text} task now.",
        payload: descriptionController.text,
        date: dateValue,
        time: timeValue);
    notifyListeners();
  }

//updating firestore all tasks

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
      var date = dateValue.split('/').toList();
      var dateExp = '${date[1]}/${date[0]}/${date[2]}';
      String time = timeValue;
      String dateTime = '$dateExp ${time.split(' ').join()}';
      print('NewDate: $dateExp ${time.split(' ').join()}');
      DateTime newDate = DateFormat("dd/MM/yyyy hh:mma").parse(dateTime);
      print('Date: ${DateTime.now()}');
      print('newDate: $newDate');

      if (newDate.isAfter(DateTime.now())) {
        taskState = 'upcoming';
      } else {
        taskState = 'finished';
      }

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
      //5 minutes before notification
      LocalNotifications.showScheduleNotification(
          minute: 5,
          title: "Get ready! ${titleController.text} is scheduled soon.",
          body:
              "This is a friendly reminder for your task Scheduled Time:$timeValue",
          payload: descriptionController.text,
          date: dateValue,
          time: timeValue);
      //Current time notification
      LocalNotifications.showScheduleNotification(
          minute: 0,
          title: "Your Time is Now!",
          body: "Time is ticking! Do your ${titleController.text} task now.",
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
    dateValue = "dd/MM/yyyy";
    timeValue = "hh:mma";
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

  updateTimeDateState(String date1, String time1, String docId) {
    var date = date1.split('/').toList();
    var dateExp = '${date[1]}/${date[0]}/${date[2]}';
    String time = time1;
    String dateTime = '$dateExp ${time.split(' ').join()}';
    print('NewDate: $dateExp ${time.split(' ').join()}');
    DateTime newDate = DateFormat("dd/MM/yyyy hh:mma").parse(dateTime);
    print('Date: ${DateTime.now()}');
    print('newDate: $newDate');
    if (newDate.isBefore(DateTime.now())) {
      print('equal time: $docId');
      TodoService().updateTaskState1(docId, "finished");
    }
    // notifyListeners();
  }
}
