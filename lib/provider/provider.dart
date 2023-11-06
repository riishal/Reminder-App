import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/constants/alert_message.dart';

import '../model/todo_model.dart';
import '../service/todo_service.dart';

class Providerdata extends ChangeNotifier {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final format = DateFormat.yMd();
  int radioValue = 0;
  String dateValue = "dd/mm/yy";
  String timeValue = "hh : mm";
  String category = "Other";

  void setRadioValue(groupValue) {
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

  setDateAndTime(context) {
    final format = DateFormat.yMd();
    if (dateValue == "dd/mm/yy" && timeValue == "hh : mm") {
      dateValue = format.format(DateTime.now());
      timeValue = timeValue = DateFormat.jm().format(DateTime.now());
    }
    notifyListeners();
  }

  void setDate(BuildContext context) async {
    final getValue = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2025));

    switch (dateValue) {}
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
    } else {
      timeValue = DateFormat.jm().format(DateTime.now());
    }
    notifyListeners();
  }

  addTask(context) {
    setDateAndTime(context);
    TodoService().addNewTask(TodoModel(
        isDone: false,
        titleTask: titleController.text,
        description: descriptionController.text,
        category: category,
        dateTask: dateValue,
        timeTask: timeValue));
    showToast("Task added successfully");
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

  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        backgroundColor: Colors.blue.shade200,
        textColor: Colors.white);
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
      print("Notification");
    }
  }
}
