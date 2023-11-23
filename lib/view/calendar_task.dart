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
                              String categoryText = "OTR";

                              final category = todo["category"];
                              switch (category) {
                                case "Learn":
                                  categoryColor = Colors.green.shade500;
                                  categoryText = "LRN";

                                  break;
                                case "Work":
                                  categoryColor = Colors.blue.shade500;
                                  categoryText = "WRK";
                                  break;
                                case "Genarel":
                                  categoryColor = Colors.amber.shade500;
                                  categoryText = "GEN";
                                  break;
                              }

                              return Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: categoryColor),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  margin: const EdgeInsets.all(8),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.only(
                                        right: 10, left: 7),
                                    leading: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: categoryColor, width: 2),
                                          color: categoryColor,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      height: double.infinity,
                                      width: 35,
                                      child: Center(
                                          child: Text(
                                        categoryText,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ),
                                    title: Text(
                                      todo['titleTask'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          todo['description'],
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          todo['timeTask'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                      ],
                                    ),
                                    trailing: Text(
                                      todo['dateTask'],
                                      style: const TextStyle(
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
