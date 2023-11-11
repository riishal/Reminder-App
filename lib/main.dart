import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/add_task_provider.dart';
import 'package:todo_app/provider/task_home_provider.dart';
import 'package:todo_app/service/notification_helper.dart';

import 'package:todo_app/view/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.requestNotificationPermission();
  await LocalNotifications.init();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AddTaskProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TaskHomeProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
