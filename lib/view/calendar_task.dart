import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo_app/provider/add_task_provider.dart';

class CalendarTask extends StatefulWidget {
  const CalendarTask({super.key});

  @override
  State<CalendarTask> createState() => _CalendarTaskState();
}

class _CalendarTaskState extends State<CalendarTask> {
  @override
  void initState() {
    var provider = Provider.of<AddTaskProvider>(context, listen: false);
    provider.getTask(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddTaskProvider>(builder: (context, getdata, child) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime(2021),
                lastDate: DateTime(2025),
                onDateChanged: (selectedDate) {
                  getdata.getTask(selectedDate);
                  getdata.setCalendarDate(selectedDate);
                  print(selectedDate);
                },
              ),
              Expanded(
                child: StreamBuilder(
                    stream: getdata.dateStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.isEmpty) {
                          return const Center(
                            child: Text('Empty Tasks'),
                          );
                        }
                        var length = snapshot.data.length;
                        print('lenghthh: $length');
                        return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              var todo = snapshot.data[index];
                              Color categoryColor = Colors.black;

                              final category = todo["category"];
                              switch (category) {
                                case "Learn":
                                  categoryColor = Colors.green.shade500;

                                  break;
                                case "Work":
                                  categoryColor = Colors.blue.shade500;
                                  break;
                                case "Genarel":
                                  categoryColor = Colors.amber.shade500;
                                  break;
                              }

                              return Card(
                                  color: categoryColor,
                                  child: ListTile(
                                    title: Text(
                                      todo['titleTask'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          todo['description'],
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          todo['timeTask'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                      ],
                                    ),
                                    trailing: Text(
                                      todo['dateTask'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ));
                            });
                      }
                      return Container();
                    }),
              )
            ],
          ),
        ),
      );
    });
  }
}
