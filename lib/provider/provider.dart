import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/todo_model.dart';
import '../service/todo_service.dart';

class Providerdata extends ChangeNotifier {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  int radioValue = 0;
  String dateValue = "dd/mm/yy";
  String timeValue = "hh : mm";
  String category = "";

  void setRadioValue(groupValue) {
    radioValue = groupValue;
    switch (groupValue) {
      case 1:
        category = "Learning";
        break;
      case 2:
        category = "Working";
        break;
      case 3:
        category = "Genarel";
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
      final format = DateFormat.yMd();
      dateValue = format.format(getValue);
    }
    notifyListeners();
  }

  void setTime(BuildContext context) async {
    final getTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (getTime != null) {
      timeValue = getTime.format(context);
    }
    notifyListeners();
  }

  addTask() {
    print('aded');
    TodoService().addNewTask(TodoModel(
        isDone: false,
        titleTask: titleController.text,
        description: descriptionController.text,
        category: category,
        dateTask: dateValue,
        timeTask: timeValue));
    print("Data saving");
  }

  void clear(context) {
    titleController.clear();
    descriptionController.clear();
    radioValue = 0;
    dateValue = "dd/mm/yy";
    timeValue = "hh : mm";
    Navigator.pop(context);
  }

  updateTask(String docId, bool valueUpdate) {
    print('update');
    print(valueUpdate);
    TodoService().updateTask(docId, valueUpdate);
  }

  void delectTask(docId) {
    TodoService().delectTask(docId);
  }
}
