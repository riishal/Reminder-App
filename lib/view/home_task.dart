import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/show_task_model.dart';
import 'package:todo_app/provider/add_task_provider.dart';
import 'package:todo_app/widgets/card_todo_widget.dart';

import '../core/constents.dart';
import '../provider/task_home_provider.dart';

int buttonIndex = 0;

class HomeTask extends StatefulWidget {
  const HomeTask({super.key});

  @override
  State<HomeTask> createState() => _HomeTaskState();
}

class _HomeTaskState extends State<HomeTask>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late AddTaskProvider addTaskProvider;
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    addTaskProvider = Provider.of<AddTaskProvider>(context, listen: false);
    super.initState();
  }

  Future<void> refresh() async {
    FirebaseFirestore.instance.collection('todoApp').get();
    return Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('EEEE, MMMM d, y').format(DateTime.now());

    var size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        // appBar: AppBar(
        //   title: Text(
        //     "Todo App",
        //     style: TextStyle(color: Colors.black),
        //   ),
        //   backgroundColor: Colors.white,
        //   elevation: 0,
        // ),

        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Today\'s Task',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            todayDate.toString(),
                            style: TextStyle(color: Colors.grey.shade600),
                          )
                        ]),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TabBar(
                    onTap: (index) {
                      setState(() {
                        tabController.index = index;
                      });
                    },
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(30), // Creates border
                      color:
                          tabController.index == 1 ? Colors.red : Colors.blue,
                    ),
                    controller: tabController,
                    unselectedLabelColor: Colors.black,
                    labelColor: Colors.white,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelPadding: const EdgeInsets.symmetric(vertical: 8),
                    tabs: [
                      Text(
                        'Upcoming Tasks',
                        // style: TextStyle(color: Colors.blue)
                      ),
                      Text(
                        'Completed Tasks',
                        // style: TextStyle(color: Colors.red.shade500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: TabBarView(controller: tabController, children: [
                    taskContainer(size, "upcoming", TaskState.upcoming),
                    taskContainer(size, "finished", TaskState.finished)
                  ]),
                )
              ],
            ),
          ),
        ));
  }

  Widget taskContainer(Size size, String state, TaskState taskState) {
    // var time = FirebaseFirestore.instance.collection('todoApp').get();
    // time.then(
    //   (value) => print('${value.docs[0]['timeTask']}'),
    // );
    return Consumer<TaskHomeProvider>(builder: (context, getdata, child) {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('todoApp')
              .where('taskState', isEqualTo: state)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final documents = snapshot.data!.docs;
              // getdata.checkTaskConditions(snapshot.data!.docs, taskState);
              print(documents.toString());
              return SizedBox(
                height: 500,
                child: RefreshIndicator(
                  onRefresh: refresh,
                  color: Colors.white,
                  backgroundColor: Colors.black,
                  strokeWidth: 4.0,
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        QueryDocumentSnapshot<Map<String, dynamic>> data =
                            snapshot.data!.docs[index];
                        // addTaskProvider.updateTimeDateState(
                        //     data["dateTask"], data["timeTask"], data.id);
                        return Material(
                          color: Colors.transparent,
                          child: Ink(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: data["taskState"] == "finished"
                                          ? Colors.red
                                          : Colors.black,
                                      blurRadius: 1,
                                      offset: Offset(10, 10))
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                            child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  buttonIndex = index;

                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    context: context,
                                    builder: (context) => AddNewTask(
                                      size: size,
                                      index: index,
                                      data: data,
                                    ),
                                  );

                                  // print(buttonIndex);
                                  addTaskProvider
                                      .updateRadioValue(data["category"]);
                                  addTaskProvider.titleController.text =
                                      data["titleTask"];
                                  addTaskProvider.descriptionController.text =
                                      data["description"];
                                  addTaskProvider.dateValue =
                                      data["dateTask"].toString();
                                  addTaskProvider.timeValue =
                                      data["timeTask"].toString();
                                  addTaskProvider.updateOnCheckedOnedayBefore(
                                      data["isOnedayChecked"]);
                                  addTaskProvider.updateOnCheckedTenMinutes(
                                      data["isTenMinutesChecked"]);
                                },
                                child: CardTodoListWidget(data: data)),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 15,
                          ),
                      itemCount: documents.length),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          });
    });
  }
}
