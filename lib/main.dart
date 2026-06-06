import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/job_controller.dart';
import 'screens/home_screen.dart';

void main() {
  Get.put(JobController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HireHub',
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
