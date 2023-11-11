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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late TaskHomeProvider taskHomeProvider;
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    taskHomeProvider = Provider.of<TaskHomeProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('EEEE, MMMM d, y').format(DateTime.now());

    var size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        // appBar: AppBar(
        //   title: Text(
        //     "Todo App",
        //     style: TextStyle(color: Colors.black),
        //   ),
        //   backgroundColor: Colors.white,
        //   elevation: 0,
        // ),
        body: SafeArea(
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
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD5E8FA),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          foregroundColor: Colors.blue.shade800),
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          context: context,
                          builder: (context) => AddNewTask(
                            size: size,
                          ),
                        );
                      },
                      child: const Text(
                        "+ New Task",
                        style: TextStyle(color: Colors.indigo),
                      ))
                ],
              ),
              TabBar(
                controller: tabController,
                labelColor: Colors.purple,
                unselectedLabelColor: Colors.purple.shade200,
                indicatorColor: Colors.purple,
                indicatorSize: TabBarIndicatorSize.tab,
                labelPadding: const EdgeInsets.symmetric(vertical: 8),
                tabs: const [
                  Text('Upcoming'),
                  Text('finished'),
                ],
              ),
              Expanded(
                child: TabBarView(controller: tabController, children: [
                  taskContainer(size, "upcoming", TaskState.upcoming),
                  taskContainer(size, "finished", TaskState.finished)
                ]),
              )
            ],
          ),
        ));
  }

  Widget taskContainer(Size size, String state, TaskState taskState) {
    return Consumer<TaskHomeProvider>(builder: (context, getdata, child) {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('todoApp')
              .where('taskState', isEqualTo: state)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final documents = snapshot.data!.docs;
              taskHomeProvider.checkTaskConditions(
                  snapshot.data!.docs, taskState);

              return Container(
                height: 500,
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      QueryDocumentSnapshot<Map<String, dynamic>> data =
                          snapshot.data!.docs[index];
                      return Material(
                        color: Colors.transparent,
                        child: Ink(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                buttonIndex = index;

                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  context: context,
                                  builder: (context) => AddNewTask(
                                    size: size,
                                    index: index,
                                    data: data,
                                  ),
                                );
                                // print(buttonIndex);
                                // getdata
                                //     .updateRadioValue(data["category"]);
                                // getdata.titleController.text =
                                //     data["titleTask"];
                                // getdata.descriptionController.text =
                                //     data["description"];
                                // getdata.dateValue =
                                //     data["dateTask"].toString();
                                // getdata.timeValue =
                                //     data["timeTask"].toString();
                              },
                              child: CardTodoListWidget(data: data)),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 15,
                        ),
                    itemCount: documents.length),
              );
            }
            return const Center(child: CircularProgressIndicator());
          });
    });
  }
}
