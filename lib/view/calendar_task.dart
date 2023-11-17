import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/add_task_provider.dart';

class CalendarTask extends StatelessWidget {
  const CalendarTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddTaskProvider>(builder: (context, getdata, child) {
      return Scaffold(
        body: SafeArea(
            child: CalendarDatePicker(
          initialDate: DateTime.now(),
          firstDate: DateTime(2021),
          lastDate: DateTime(2025),
          onDateChanged: (selectedDate) {
            print(selectedDate);
          },
        )),
      );
    });
  }
}
