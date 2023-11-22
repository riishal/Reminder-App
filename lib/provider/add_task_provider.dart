import 'dart:async';

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
  bool visibility = false;
  bool reminderVisibility = false;
  StreamController dateController = StreamController.broadcast();
  Sink get dateSink => dateController.sink;
  Stream get dateStream => dateController.stream;
  bool isTenMinutesChecked = false;
  bool isOneDayBeforeChecked = false;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  TaskState initialTaskState = TaskState.upcoming;
  final format = DateFormat.yMd();
  int radioValue = 0;
  String dateValue = "dd/MM/yyyy";
  String timeValue = "hh:mma";
  String reminderValue = "hh:mma";
  String category = "Other";
  int tenminutesValue = 0;
  int ondayValue = 0;

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

  setVisibility() {
    visibility = !visibility;
    notifyListeners();
  }

  setReminderVisibility() {
    reminderVisibility = !reminderVisibility;
    notifyListeners();
  }

  onCheckedTenMinutes(value) {
    isTenMinutesChecked = value;
    if (isTenMinutesChecked == true) {
      tenminutesValue = 10;
    }

    notifyListeners();
  }

  updateOnCheckedTenMinutes(value) {
    if (value == 10) {
      isTenMinutesChecked = true;
    }
    notifyListeners();
  }

  updateOnCheckedOnedayBefore(value) {
    if (value == 1) {
      isOneDayBeforeChecked = true;
    }
    notifyListeners();
  }

  onCheckedOneDayBefore(value) {
    isOneDayBeforeChecked = value;
    if (isOneDayBeforeChecked == true) {
      ondayValue = 1;
    }
    notifyListeners();
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
    if (dateValue == "dd/MM/yyyy" &&
        timeValue == "hh:mma" &&
        reminderValue == "hh:mma") {
      dateValue = format.format(DateTime.now());
      timeValue = DateFormat('hh:mma').format(DateTime.now());
      reminderValue = DateFormat('hh:mma')
          .format(DateTime.now().subtract(const Duration(minutes: 5)));
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
      reminderValue = TimeOfDay.fromDateTime(
              DateTime.now().subtract(const Duration(minutes: 5)))
          .format(context);
      print('////////// time value: $timeValue');
    } else {
      timeValue = DateFormat('hh:mma').format(DateTime.now());
      print('////////// time value: $timeValue');
    }
    notifyListeners();
  }

  void setReminder(BuildContext context) async {
    final getTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
            DateTime.now().subtract(const Duration(minutes: 5))));
    if (getTime != null) {
      reminderValue = getTime.format(context);
      print('////////// reminder value: $reminderValue');
    } else {
      reminderValue = DateFormat('hh:mma')
          .format(DateTime.now().subtract(const Duration(minutes: 5)));
      print('////////// reminder value: $reminderValue');
    }
    notifyListeners();
  }

//showing calendar tasks
  getTask(DateTime selectedDate) async {
    var todos = await TodoService().getTasks(selectedDate);
    dateSink.add(todos);
  }

  //set calender date
  void setCalendarDate(DateTime selectedDate) {
    dateValue = format.format(selectedDate);
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
        isOnedayChecked: ondayValue,
        isTenMinutesChecked: tenminutesValue,
        taskState: taskState,
        isDone: false,
        titleTask: titleController.text,
        description: descriptionController.text,
        category: category,
        dateTask: dateValue,
        timeTask: timeValue));

    //onday before notification
    //10 minutes before notification
    LocalNotifications.showScheduleNotification(
        // dayy: ondayValue,
        // minute: tenminutesValue,
        title: "Get ready! ${titleController.text} is scheduled soon.",
        body:
            "This is a friendly reminder for your task Scheduled Time:$reminderValue",
        payload: descriptionController.text,
        date: dateValue,
        time: reminderValue);
    //Current time notification
    LocalNotifications.showScheduleNotification(
        // dayy: 0,
        // minute: 0,
        title: "Your Time is Now!",
        body: "Time is ticking! Do your ${titleController.text} task now.",
        payload: descriptionController.text,
        date: dateValue,
        time: reminderValue);
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
              isOnedayChecked: ondayValue,
              isTenMinutesChecked: tenminutesValue,
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
          // dayy: ondayValue,
          // minute: tenminutesValue,
          title: "Get ready! ${titleController.text} is scheduled soon.",
          body:
              "This is a friendly reminder for your task Scheduled Time:$timeValue",
          payload: descriptionController.text,
          date: dateValue,
          time: reminderValue);
      //Current time notification
      LocalNotifications.showScheduleNotification(
          // dayy: 0,
          // minute: 0,
          title: "Your Time is Now!",
          body: "Time is ticking! Do your ${titleController.text} task now.",
          payload: descriptionController.text,
          date: dateValue,
          time: reminderValue);

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
    isOneDayBeforeChecked = false;
    isTenMinutesChecked = false;
    visibility = false;
    reminderVisibility = false;

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

  moveToComplete(String docId) {
    var date = format.format(DateTime.now());
    var time =
        DateFormat('hh:mma').format(DateTime.now().add(Duration(minutes: -2)));

    TodoService().moveToCompleteTask(docId, date, time, "finished");
    print("$date//$time");
  }
}
